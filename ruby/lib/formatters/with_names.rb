module Repent
  module Formatters
    class WithNames

      def initialize(formatter, name_formatter:, padding: 1)
        @formatter = formatter
        @name_formatter = name_formatter
        @padding = padding
      end

      def format(text, sender:, &handler)
        @name_formatter.format(sender, sender: sender, &handler) unless same?(sender)
        @formatter.format(text, sender: sender) do |result|
          handler.call(result.center(result.size + padding_size))
        end
      end

    private

      def same?(sender)
        (sender == @previous_sender).tap do
          @previous_sender = sender
        end
      end

      def padding_size
        @padding * 2
      end

    end
  end
end
