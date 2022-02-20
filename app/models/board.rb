module Model
  class Board
    attr_reader :lands, :locale, :card_deck

    def initialize
      # TODO: later use this to switch between international version and other versions
      # @locale = locale
    end

    private

    def initiate_lands

    end

    def initiate_card_deck
      card_deck = []
      card_deck << Model::Card.new("Overspeeding", "You violated traffic rules by overspeeding and got caught by the police.", -150)
      card_deck << Model::Card.new("Top Entrepreneurs Award", "You got an award for being one of the inspiring top entrepreneurs.", 100)
      card_deck << Model::Card.new("Go To Jail", "Police has the proof for a case of money crime, you are getting jailed and fined for it. You can bail or stay in jail (skipping 2 rounds)", 0)
      card_deck << Model::Card.new("VIP Flight to Start", "You got VIP flight to go straight to Start.", 0)
      card_deck << Model::Card.new("Illegal Parking", "You parked your call illegally and got fined.", -100)
      card_deck << Model::Card.new("Host the World Carnival", "You successfully hosted a fantastic world carnival.", 200)
      card_deck << Model::Card.new("Free from Jail", "You can use this card to free yourself from jail later.", 0)
      card_deck.shuffle!
    end
  end
end
