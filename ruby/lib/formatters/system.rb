module Repent
  module Formatters
    class System

      def initialize(standard_format, system_name: 'system')
        @standard_format = standard_format
        @system_name = system_name
      end

      def format(message, &handler)
        if message.sender == @system_name
          handler.call(message.text)
        else
          @standard_format.format(message, &handler)
        end
      end

    end
  end
end
