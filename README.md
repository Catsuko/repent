# Repent

A simple command line chat system implemented using [gRPC](https://grpc.io/docs/what-is-grpc/introduction).

## Requirements

- Ruby 3.2+
- Redis 7.2+

## Getting Started

Run the chat server with:

```shell
./ruby/bin/chat_server
```

Then connect clients using:

```shell
./ruby/bin/chat_client albert
```

The client also accepts a custom chat room name if you want some privacy:

```shell
./ruby/bin/chat_client bart treehouse_of_horrors
```

## Development

After changing the service definitions, rebuild the generated server/client files with:

```shell
$ grpc_tools_ruby_protoc --ruby_out=./ruby/lib --grpc_out=./ruby/lib ./repent.proto
```