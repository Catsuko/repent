require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

name = ARGV[0]
room_name = ARGV[1].to_s.strip
client = Repent::Client.new(
  name:      name,
  room_name: room_name.empty? ? 'global' : room_name,
  formatter: Repent::Formatters.messenger(name)
)

client.join(chat_room)
