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

    def join(member, call)
      raise GRPC::AlreadyExists unless add_to_room?(member.name)

      broadcast("#{member.name} joined the room", sender: SYSTEM_SENDER)
      inbox = Queue.new

      Enumerator.new do |stream|
        Sync do
          Async(transient: true) { listen_for_messages(member.name, inbox: inbox) }
          Async do
            until inbox.closed?
              next_message = inbox.pop
              if next_message
                sender, text = next_message.split(@delimiter)
                stream.yield(Message.new(sender: sender, text: text))
              end
            end
          end
        end
      end
    end

    def leave(member, _call)
      @redis.pipelined do |pipeline|
        pipeline.publish(disconnect_channel, member.name)
        pipeline.srem(member_set_key, member.name)
      end
      Empty.new
    end

    def say(content, _call)
      broadcast(content.text, sender: content.sender, receiver: content.receiver)
      Empty.new
    end

  private

    def broadcast(text, sender:, receiver: nil)
      @redis.publish(message_channel, "#{sender}#{@delimiter}#{text}")
    end

    def member_set_key
      "chat_room:members"
    end

    def message_channel
      "chat_room:message"
    end

    def disconnect_channel
      "chat_room:disconnect"
    end

    def add_to_room?(name)
      name != SYSTEM_SENDER && @redis.sadd(member_set_key, name).positive?
    end

    def listen_for_messages(name, inbox:)
      subscriber = Redis.new
      subscriber.subscribe(message_channel, disconnect_channel) do |on|
        on.message do |channel, payload|
          case channel
          when message_channel
            inbox << payload
          when disconnect_channel
            subscriber.unsubscribe(message_channel, disconnect_channel) if name == payload
          end
        end
        on.unsubscribe do |channel, sub_count|
          inbox.close if channel == message_channel
        end
      end
    end

  end
end
