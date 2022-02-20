module Model
  class Land
    attr_reader :index, :description, :land_type

    LAND_TYPE = {
      construction: 1,
      infra: 2,
      jail: 3,
      expense: 4,
      chance: 5
    }

    def initialize(index, title, description, land_type, price = 0)
      @index = index
      @title = title
      @description = description
      @land_type = land_type
      @price = price
    end
  end
end
