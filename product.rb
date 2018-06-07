require 'securerandom'
require_relative 'event_sourced_aggregate'
require_relative 'product_events'

module Sample
  class Product < EventSourcedAggregate
    attr_reader :id, :sale_prices

    def initialize
      @id = SecureRandom.uuid
      @sale_prices = []
      register_event_handlers
    end

    def add_sale_price(price_type:, price_amount:)
      apply_changes(SalePriceAdded.new(id: id,
                                       price_id: SecureRandom.uuid,
                                       price_type: price_type,
                                       price_amount: price_amount))
    end

    def remove_sale_price(price_id:)
      apply_changes(SalePriceRemoved.new(id: id, price_id: price_id))
    end

    private

    def apply(event)
      @event_handlers[event.class].call(event)
    end

    def register_event_handlers
      @event_handlers = {}
      @event_handlers[SalePriceAdded] = ->(event) { add_sale_price_handler(event) }
      @event_handlers[SalePriceRemoved] = ->(event) { remove_sale_price_handler(event) }
    end

    def add_sale_price_handler(event)
      @sale_prices << SalePrice.new(id: event.price_id, type: event.price_type, amount: event.price_amount)
    end

    def remove_sale_price_handler(event)
      @sale_prices.reject! { |price| price.id == event.price_id }
    end
  end

  class SalePrice
    attr_reader :id, :type, :amount

    def initialize(id:, type:, amount:)
      @id = id
      @type = type
      @amount = amount
    end
  end
end
