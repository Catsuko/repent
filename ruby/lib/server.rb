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
      raise GRPC::AlreadyExists unless add_to_room?(member)

      broadcast("#{member.name} joined the room", room: member.room, sender: SYSTEM_SENDER)
      inbox = Queue.new

      Enumerator.new do |stream|
        Sync do
          Async(transient: true) { listen_for_messages(member, inbox: inbox) }
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
        pipeline.publish(disconnect_channel(member.room), member.name)
        pipeline.srem(member_set_key(member.room), member.name)
      end
      Empty.new
    end

    def say(content, _call)
      text = content.text.delete(@delimiter).strip
      broadcast(text, sender: content.sender, room: content.room, receiver: content.receiver) unless text.empty?
      Empty.new
    end

  private

    def broadcast(text, sender:, room:, receiver: nil)
      @redis.publish(message_channel(room), "#{sender}#{@delimiter}#{text}")
    end

    def member_set_key(room)
      "chat_room:#{room}:members"
    end

    def message_channel(room)
      "chat_room:#{room}:message"
    end

    def disconnect_channel(room)
      "chat_room:#{room}:disconnect"
    end

    def add_to_room?(member)
      member.name != SYSTEM_SENDER && @redis.sadd(member_set_key(member.room), member.name).positive?
    end

    def listen_for_messages(member, inbox:)
      subscriber = Redis.new
      room_message_channel = message_channel(member.room)
      room_dc_channel = disconnect_channel(member.room)
      subscriber.subscribe(room_message_channel, room_dc_channel) do |on|
        on.message do |channel, payload|
          case channel
          when room_message_channel
            inbox.push(payload)
          when room_dc_channel
            subscriber.unsubscribe(room_message_channel, room_dc_channel) if member.name == payload
          end
        end
        on.unsubscribe do |channel, sub_count|
          inbox.close if channel == room_message_channel
        end
      end
    end

  end
end
