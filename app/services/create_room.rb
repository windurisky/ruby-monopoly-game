module Service
  class CreateRoom < Base
    def initialize(username, websocket)
      @username = username
      @websocket = websocket
    end

    def run!
      player = Model::Player.new(@username, @websocket)
      room = Model::Room.new(player)
      [room, player]
    end
  end
end
