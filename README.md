# Repent

```shell
$ grpc_tools_ruby_protoc --ruby_out=./ruby/lib --grpc_out=./ruby/lib ./repent.proto
```

```shell
ruby ruby/scripts/chat_server.rb
```

```shell
ruby ruby/scripts/chat_client.rb <name>
```
