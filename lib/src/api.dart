/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import '../game.dart'; // FIXME

import 'generated/common.pb.dart';
import 'generated/model.pb.dart';
import 'generated/master.pb.dart';
import 'generated/master.pbgrpc.dart';

export 'generated/common.pb.dart';
export 'generated/model.pb.dart';
export 'generated/master.pb.dart';
export 'generated/master.pbgrpc.dart';

////////////////////////////////////////////////////////////////////////////////

@deprecated
class Client extends SessionClient {
  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();

  @deprecated
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

  //Future<HelloResponse> helloSimple(final String version) async {
  //  return hello(HelloRequest()..version = version);
  //}
}

////////////////////////////////////////////////////////////////////////////////

@deprecated
class ClientChannel extends gRPC.ClientChannel {
  @deprecated
  ClientChannel(
    final String host, {
      final int port = 443,
      final gRPC.ChannelOptions options = const gRPC.ChannelOptions(),
    })
    : super(host, port: port, options: options);
}
