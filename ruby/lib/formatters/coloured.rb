require 'rainbow'

module Repent
  module Formatters
    class Coloured

      def initialize(color)
        @color = color
      end

      def format(text, *, &handler)
        handler.call(Rainbow(text).public_send(@color))
      end

    end
  end
end
