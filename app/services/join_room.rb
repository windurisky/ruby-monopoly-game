module Service
  class JoinRoom < Base
    def initialize(username, room)
      @username = username
      @room = room
    end

    def run!
      validate_username!
      player = Model::Player.new(@username)
      @room.add_player(player)
      @room
    end

    private

    def validate_username!
      username_exists = @room.players.any? { |p| p.username == @username }
      raise 'username already exists in the room' if username_exists
    end
  end
end