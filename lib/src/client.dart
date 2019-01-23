/* This is free and unencumbered software released into the public domain. */

import 'package:grpc/grpc.dart' as gRPC;

import 'generated/master.pbgrpc.dart';

import 'api.dart' as API;
import 'connection.dart' show Connection;

////////////////////////////////////////////////////////////////////////////////

class Client {
  final SessionClient _stub;

  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();

  Client(final Connection conn)
    : _stub = SessionClient(conn.channel) {}

  SessionClient get rpc => _stub;

  Future<void> ping() async => await rpc.ping(API.Nothing());
}
