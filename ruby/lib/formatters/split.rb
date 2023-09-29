module Repent
  module Formatters
    class Split

      def initialize(name, on_match:, fallback:)
        @name = name
        @on_match = on_match
        @fallback = fallback
      end

      def format(message, &handler)
        formatter = message.sender == @name ? @on_match : @fallback
        formatter.format(message, &handler)
      end

    end
  end
end
