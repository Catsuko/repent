require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

client = Repent::Client.new(name: ARGV[0])
client.join(chat_room)
