module Model
  class Room
    attr_reader :code, :instruction_locale, :board_locale, :board, :players

    def initialize(player)
      @player = player
      @code = Utility::CodeGenerator.generate
      @board = Board.new
    end

    def invite_link
      "/join/#{@code}"
    end
  end
end
