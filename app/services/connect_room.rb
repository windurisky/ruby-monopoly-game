module Service
  class ConnectRoom < Base
    def initialize(user_id, username, room, websocket)
      @user_id = user_id
      @username = username
      @room = room
      @websocket = websocket
    end

    def run!
      player.replace_websocket_connection(@websocket)
      @room.players.map! do |p|
        p.user_id == @user_id && p.username == @username ? player : p
      end
      [@room, player]
    end

    private

    def player
      player = @room.players.select { |p| p.user_id == @user_id && p.username == @username }.first
      raise 'invalid user' if player.nil?
      player
    end
  end
end
