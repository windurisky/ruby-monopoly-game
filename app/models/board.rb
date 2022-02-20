module Model
  class Board
    attr_reader :lands, :locale, :card_deck

    def initialize(locale)
      @locale = locale
    end

    private

    def initiate_lands
    end

    def initiate_card_deck
    end
  end
end
