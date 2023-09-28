module Repent
  module Formatters
    class Justified

      def initialize(left: true, width: 50)
        @left = left
        @width = width
      end

      def format(message, &handler)
        handler.call(@left ? message.text.ljust(@width) : message.text.rjust(@width))
      end
    end
  end
end
