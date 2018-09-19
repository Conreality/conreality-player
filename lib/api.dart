/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import 'game.dart';

import 'generated/conreality.pb.dart';
import 'generated/conreality.pbgrpc.dart';

export 'generated/conreality.pb.dart';
export 'generated/conreality.pbgrpc.dart';

////////////////////////////////////////////////////////////////////////////////

class Client extends MasterClient {
  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();

  Client(final Game game)
    : super(ClientChannel(game.host(),
        port: game.port(),
        options: gRPC.ChannelOptions(credentials: creds),
      ));

  void dispose() {}

  void connect() async {}

  Future<Null> disconnect() async {
    //return _channel.shutdown(); // FIXME: fix upstream bug first
    return Future.value();
  }

  Future<HelloResponse> helloSimple(final String version) async {
    return hello(HelloRequest()..version = version);
  }
}

////////////////////////////////////////////////////////////////////////////////

class ClientChannel extends gRPC.ClientChannel {
  ClientChannel(
    final String host, {
      final int port = 443,
      final gRPC.ChannelOptions options = const gRPC.ChannelOptions(),
    })
    : super(host, port: port, options: options);
}
