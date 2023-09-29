require 'async'
require_relative 'repent_services_pb'

module Repent
  class Client

    def initialize(name:, formatter:)
      @name = name
      @formatter = formatter
    end

    def join(chat_room)
      Sync do
        Async(transient: true) { receive_messages(chat_room) }
        Async { send_messages(chat_room) }
      end
    end

  private

    def receive_messages(chat_room)
      Thread.new do
        message_stream = chat_room.join(JoinRequest.new(name: @name))
        message_stream.each do |message|
          @formatter.format(message.text, sender: message.sender) do |line|
            STDOUT.puts(line)
          end
        end
      end
    end

    def send_messages(chat_room)
      loop do
        text = STDIN.gets.chomp.tap { STDOUT.print "\e[A\e[2K" }
        chat_room.say(MessageContent.new(text: text, sender: @name))
      end
    end

  end
end
