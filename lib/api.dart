/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import 'game.dart';

import 'generated/conreality.pb.dart';
import 'generated/conreality.pbgrpc.dart';

export 'generated/conreality.pb.dart';
export 'generated/conreality.pbgrpc.dart';

class Client {
  final gRPC.ChannelCredentials _creds = gRPC.ChannelCredentials.insecure();
  gRPC.ClientChannel _channel;

  Client(final Game game) {
    _channel = gRPC.ClientChannel(game.host(),
      port: game.port(),
      options: gRPC.ChannelOptions(credentials: _creds),
    );
  }

  void dispose() {}

  void connect() async {}

  Future<Null> disconnect() async {
    return _channel.shutdown();
  }

  Future<HelloResponse> hello(final String version) async {
    final stub = MasterClient(_channel);
    return await stub.hello(HelloRequest()..name = version); // FIXME
  }
}
