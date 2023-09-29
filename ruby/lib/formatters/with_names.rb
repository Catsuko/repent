module Repent
  module Formatters
    class WithNames

      def initialize(formatter, padding: 1)
        @formatter = formatter
        @padding = padding
      end

      def format(message, &handler)
        yield(message.sender) unless same_sender?(message)
        @formatter.format(message) do |result|
          handler.call(result.center(result.size + padding_size))
        end
      end

    private

      def same_sender?(message)
        (message.sender == @previous_sender).tap do
          @previous_sender = message.sender
        end
      end

      def padding_size
        @padding * 2
      end

    end
  end
end
