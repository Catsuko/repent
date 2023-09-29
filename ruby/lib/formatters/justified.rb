module Repent
  module Formatters
    class Justified

      def initialize(formatter, left: true, width: 50)
        @formatter = formatter
        @left = left
        @width = width
      end

      def format(text, sender:, &handler)
        @formatter.format(text, sender: sender) do |result|
          handler.call(@left ? result.ljust(@width) : result.rjust(@width))
        end
      end
    end
  end
end
