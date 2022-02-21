module Service
  class CreateRoom < Base
    def initialize(username)
      @username = username
    end

    def run!
      player = Model::Player.new(@username)
      room = Model::Room.new(player)
    end
  end
end
