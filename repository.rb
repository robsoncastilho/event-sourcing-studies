require_relative 'product'
require 'mongo'

module Sample
  class Repository
    def initialize
      @client = Mongo::Client.new(['127.0.0.1:27017'], database: 'event-sourcing-test')
    end

    def find_by_id(aggregate_root_id)
      collection = collection_name(aggregate_root_id)

      events = @client[collection].find(id: aggregate_root_id).map do |document|
        event_data = symbolize_keys(remove_unapplicable_keys(document))
        Object.const_get(document[:event]).new(event_data)
      end

      aggregate_root = Product.new
      aggregate_root.replay(events)

      aggregate_root
    end

    def append(aggregate_root, expected_version)
      collection = collection_name(aggregate_root.id)
      @client[collection].insert_many(aggregate_root.uncommitted_changes.map(&:to_h))

      # publish events

      aggregate_root.mark_changes_as_committed
      nil
    end

    private

    def collection_name(aggregate_root_id)
      "Product-#{aggregate_root_id}".to_sym
    end

    def remove_unapplicable_keys(hash)
      hash.reject { |key| key == 'event' || key == '_id' }
    end

    def symbolize_keys(hash)
      hash.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
    end
  end
end
