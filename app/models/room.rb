module Model
  class Room
    attr_reader :code, :instruction_locale, :board_locale, :board, :players

    def initialize(player)
      @players = []
      @players << player
      @code = Utility::CodeGenerator.generate
      @board = Board.new
    end

    def invite_link
      "/join/#{@code}"
    end

    def add_player(player)
      @players << player
    end

    def websocket_send(response)
      @players.each { |p| p.websocket&.send(response) }
    end
  end
end
