require 'async'
require 'grpc'
require 'redis'
require_relative 'repent_services_pb'

module Repent
  class Server < ChatRoom::Service

    SYSTEM_SENDER = 'system'

    def initialize
      @redis = Redis.new
      @delimiter = '|'
    end

    def join(request, _call)
      raise GRPC::AlreadyExists unless add_to_room?(request.name)

      broadcast("#{request.name} joined the room", sender: SYSTEM_SENDER)
      inbox = Queue.new

      Enumerator.new do |stream|
        Sync do
          Async(transient: true) { listen_for_messages(request.name, inbox: inbox) }
          Async do
            until inbox.closed?
              sender, text = inbox.pop.split(@delimiter)
              stream.yield(Message.new(sender: sender, text: text))
            end
          end
        end
      end
    end

    def say(content, _call)
      broadcast(content.text, sender: content.sender, receiver: content.receiver)
      Empty.new
    end

  private

    def broadcast(text, sender:, receiver: nil)
      @redis.publish(message_channel, "#{sender}#{@delimiter}#{text}")
    end

    def message_channel
      "chat_room:message"
    end

    def add_to_room?(name)
      name != SYSTEM_SENDER && @redis.sadd("chat_room:members", name).positive?
    end

    def listen_for_messages(name, inbox:)
      subscriber = Redis.new
      subscriber.subscribe(message_channel) do |on|
        on.message do |channel, payload|
          if inbox.closed? || inbox.size > 100
            subscriber.unsubscribe(channel)
          else
            inbox << payload
          end
        end
      end
    end

  end
end
