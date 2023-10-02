require 'async'
require_relative 'repent_services_pb'

module Repent
  class Client

    def initialize(name:, room_name:, formatter:)
      @name = name
      @room_name = room_name
      @formatter = formatter
    end

    def join(chat_room)
      Sync do
        Async(transient: true) { receive_messages(chat_room) }
        Async { send_messages(chat_room) }
      end
    rescue Interrupt
      chat_room.leave(member_details)
    end

  private

    def receive_messages(chat_room)
      Thread.new do
        message_stream = chat_room.join(member_details)
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
        chat_room.say(MessageContent.new(text: text, sender: @name, room: @room_name))
      end
    end

    def member_details
      MemberDetails.new(name: @name, room: @room_name)
    end

  end
end
