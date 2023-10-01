# Repent

A simple command line chat system implemented using [gRPC](https://grpc.io/docs/what-is-grpc/introduction).

## Requirements

- Ruby 3.2+
- Redis 7.2+

Run the chat server with:

```shell
ruby ruby/scripts/chat_server.rb
```

Then connect clients using:

```shell
ruby ruby/scripts/chat_client.rb albert
```

After changing the service definitions, rebuild the generated server/client files with:

```shell
$ grpc_tools_ruby_protoc --ruby_out=./ruby/lib --grpc_out=./ruby/lib ./repent.proto
```