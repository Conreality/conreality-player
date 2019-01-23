/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:grpc/grpc.dart' as gRPC;

import 'client.dart' show Client;

////////////////////////////////////////////////////////////////////////////////

class Connection {
  final gRPC.ClientConnection _conn;
  final gRPC.ClientChannel _channel;

  Connection._(this._conn, this._channel);

  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();
  static Connection _instance;

  static Future<Connection> get instance async {
    if (_instance == null) {
      final options = gRPC.ChannelOptions(credentials: creds); // TODO
      final channel = gRPC.ClientChannel("192.168.1.101", port: 50051, options: options);
      final conn = await channel.getConnection();
      _instance = Connection._(conn, channel);
    }
    return _instance;
  }

  gRPC.ConnectionState get state => _conn.state;

  gRPC.ClientChannel get channel => _channel;

  Client get client => Client(this);

  Future<void> close() => _channel.shutdown();

  Future<void> abort() => _channel.terminate();

  Future<void> check() => client.ping();
}
