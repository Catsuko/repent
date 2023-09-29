require_relative "../repent"

hostname = "localhost:50051"
chat_room = Repent::ChatRoom::Stub.new(hostname, :this_channel_is_insecure)

name = ARGV[0]
plain_formatter = Repent::Formatters::Plain.new
formatter = Repent::Formatters::Split.new(
  'system',
  on_match: plain_formatter,
  fallback: Repent::Formatters::Split.new(
    name,
    on_match: Repent::Formatters::Justified.new(plain_formatter, left: false),
    fallback: Repent::Formatters::Justified.new(
      Repent::Formatters::WithNames.new(plain_formatter), left: true
    )
  )
)
client = Repent::Client.new(name: name, formatter: formatter)
client.join(chat_room)
