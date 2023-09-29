module Repent
  module Formatters
    class Plain

      def format(text, *, &handler)
        handler.call(text)
      end

    end
  end
end
