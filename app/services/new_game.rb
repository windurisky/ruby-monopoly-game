module Service
  class NewGame
    def run!(username)
      player = Model::Player.new(username)
      room = Model::Room.new(player)
    end
  end
end
