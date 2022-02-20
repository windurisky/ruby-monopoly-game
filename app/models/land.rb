module Model
  class Land
    attr_reader :index, :description, :land_type

    LAND_TYPE = {
      start: 0,
      construction: 1,
      infra: 2,
      jail: 3,
      expense: 4,
      chance: 5
    }

    JAIL_BAIL_FUND = 200
    JAIL_STOP_ROUND = 2

    def initialize(index, title, description, land_type, price = 0)
      @index = index
      @title = title
      @description = description
      @land_type = land_type
      @price = price
    end

    def passing_land_modifier
      if @land_type == LAND_TYPE[:start]
        return {
          stop_round: 0,
          money: price
        }
      end
    end

    def stopping_land_modifier
      if @land_type == LAND_TYPE[:start] || @land_type == LAND_TYPE[:expense]
        return {
          stop_round: 0,
          money: price
        }
      end
    end
  end
end
