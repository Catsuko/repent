require 'async'
require_relative 'repent_services_pb'

module Repent
  class Client

    def initialize(name:)
      @name = name
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
          STDOUT.puts format_output(message)
        end
      end
    end

    def format_output(message)
      if message.sender == 'system'
        "--- #{message.text} ---"
      else
        "#{message.sender}: #{message.text}"
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
