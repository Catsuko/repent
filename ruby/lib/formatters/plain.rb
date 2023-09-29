module Repent
  module Formatters
    class Plain

      def format(message, &handler)
        handler.call(message.text)
      end

    end
  end
end
