module Repent
  module Formatters
    class Wrapped

      def initialize(formatter, width: 36)
        @formatter = formatter
        @width = width
      end

      def format(text, sender:, &handler)
        @formatter.format(text, sender: sender) do |result|
          result.scan(/.{1,#{@width}}/m) do |chunk|
            wrapped_line = chunk.strip
            handler.call(wrapped_line) unless wrapped_line.empty?
          end
        end
      end

    end
  end
end
