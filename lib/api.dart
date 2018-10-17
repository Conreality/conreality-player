/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import 'game.dart';

import 'generated/conreality_common.pb.dart';
import 'generated/conreality_master.pb.dart';
import 'generated/conreality_master.pbgrpc.dart';

export 'generated/conreality_common.pb.dart';
export 'generated/conreality_master.pb.dart';
export 'generated/conreality_master.pbgrpc.dart';

////////////////////////////////////////////////////////////////////////////////

class Client extends PublicClient {
  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();

  Client(final Game game)
    : super(ClientChannel(game.host(),
        port: game.port(),
        options: gRPC.ChannelOptions(credentials: creds),
      ));

  void dispose() {}

  void connect() async {}

  Future<void> disconnect() async {
    //return _channel.shutdown(); // FIXME: fix upstream bug first
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
