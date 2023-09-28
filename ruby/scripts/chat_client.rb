require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

name = ARGV[0]
formatter = Repent::Formatters::System.new(
  Repent::Formatters::Split.new(
    name,
    my_format:    Repent::Formatters::Justified.new(left: true),
    their_format: Repent::Formatters::Justified.new(left: false)
  )
)
client = Repent::Client.new(name: name, formatter: formatter)
client.join(chat_room)
