require 'rainbow'

module Repent
  module Formatters
    class Coloured

      def initialize(formatter, color:)
        @formatter = formatter
        @color = color
      end

      def format(text, sender:, &handler)
        @formatter.format(text, sender: sender) do |result|
          handler.call(Rainbow(result).public_send(@color))
        end
      end

    end
  end
end
