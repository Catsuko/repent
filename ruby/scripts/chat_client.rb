require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

name = ARGV[0]
formatter = Repent::Formatters::Split.new(
  'system',
  on_match: Repent::Formatters::Plain.new,
  fallback: Repent::Formatters::Split.new(
    name,
    on_match: Repent::Formatters::Justified.new(left: true),
    fallback: Repent::Formatters::Justified.new(left: false)
  )
)
client = Repent::Client.new(name: name, formatter: formatter)
client.join(chat_room)
