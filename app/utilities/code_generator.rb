module Utility
  class CodeGenerator
    CHARSET = [*'0'..'9', *'A'..'Z'].freeze
    LENGTH = 6

    class << self
      def generate
        Array.new(LENGTH) { CHARSET.sample }.join
      end
    end
  end
end
