module Sample
  class SalePriceAdded
    attr_reader :id, :price_id, :price_type, :price_amount

    def initialize(id:, price_id:, price_type:, price_amount:)
      @id = id
      @price_id = price_id
      @price_type = price_type
      @price_amount = price_amount
    end

    def to_h
      { event: self.class.name, id: @id, price_id: @price_id, price_type: @price_type, price_amount: @price_amount }
    end
  end

  class SalePriceRemoved
    attr_reader :id, :price_id

    def initialize(id:, price_id:)
      @id = id
      @price_id = price_id
    end

    def to_h
      { event: self.class.name, id: @id, price_id: @price_id }
    end
  end
end
