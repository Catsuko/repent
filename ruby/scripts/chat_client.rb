require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

name = ARGV[0]
formatter = Repent::Formatters.messenger(name)
client = Repent::Client.new(name: name, formatter: formatter)

client.join(chat_room)
