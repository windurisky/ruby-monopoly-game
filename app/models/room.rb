module Model
  class Room
    attr_reader :code, :instruction_locale, :board_locale, :board, :players

    def initialize(instruction_locale, board_locale, player)
    end

    def invite_link
      "/join/#{code}"
    end
  end
end
