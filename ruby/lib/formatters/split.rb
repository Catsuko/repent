module Repent
  module Formatters
    class Split

      def initialize(name, my_format:, their_format:)
        @name = name
        @my_format = my_format
        @their_format = their_format
      end

      def format(message, &handler)
        if message.sender == @name
          @my_format.format(message, &handler)
        else
          @their_format.format(message, &handler)
        end
      end

    end
  end
end
