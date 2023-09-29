module Repent
  module Formatters
    class Split

      def initialize(name, on_match:, fallback:)
        @name = name
        @on_match = on_match
        @fallback = fallback
      end

      def format(text, sender:, &handler)
        formatter = sender == @name ? @on_match : @fallback
        formatter.format(text, sender: sender, &handler)
      end

    end
  end
end
