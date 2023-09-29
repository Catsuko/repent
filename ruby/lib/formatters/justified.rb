module Repent
  module Formatters
    class Justified

      def initialize(formatter, left: true, width: 50)
        @formatter = formatter
        @left = left
        @width = width
      end

      def format(message, &handler)
        @formatter.format(message) do |result|
          handler.call(@left ? result.ljust(@width) : result.rjust(@width))
        end
      end
    end
  end
end
