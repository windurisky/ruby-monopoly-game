module Model
  class Player
    attr_accessor :username, :wallet

    STARTING_MONEY = 1_500

    def initialize(username)
      @username = username
      @wallet = STARTING_MONEY
      # all player always start the game at position 0
      @index = 0
    end
  end
end
