module Model
  class Card
    attr_reader :title, :description, :money, :stop_round

    def initialize(title, description, money, stop_round = 0)
      @title = title
      @description = description
      @money = money
      @stop_round = 0
    end
  end
end
