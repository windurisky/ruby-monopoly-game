require 'securerandom'

module Model
  class Player
    attr_reader :user_id, :username, :wallet, :index, :remaining_stop_round, :status, :websocket

    STARTING_MONEY = 1_500

    STATUS = {
      not_ready: 0,
      ready: 1,
      in_game: 2,
      disconnected: 3
    }

    def initialize(username, websocket, host = false)
      @user_id = SecureRandom.uuid
      @websocket = websocket
      @username = username
      @wallet = STARTING_MONEY
      @index = 0
      @remaining_stop_round = 0
      @host = host
      @status = STATUS[:not_ready]
    end

    def modify_wallet(money)
      @wallet += money
    end

    def move_index(steps)
      @index += steps
      @index -= 38 if @index > 39
      @index
    end

    def replace_websocket_connection(websocket)
      @websocket = websocket
    end
  end
end
