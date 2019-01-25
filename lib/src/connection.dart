/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:grpc/grpc.dart' as gRPC;

import 'client.dart' show Client;
import 'config.dart' show Config;

////////////////////////////////////////////////////////////////////////////////

class Connection {
  static const gRPC.ChannelCredentials creds = gRPC.ChannelCredentials.insecure();

  final gRPC.ClientConnection _conn;
  final gRPC.ClientChannel _channel;

  Connection._(this._conn, this._channel);

  static Future<Connection> to(final Uri url) async {
    assert(url != null && url.isAbsolute);

    final host = url.host;
    assert(host != null && host.isNotEmpty);

    final port = url.hasPort ? url.port : Config.DEFAULT_PORT;
    assert(port != null && port > 0 && port < 65535);

    final options = gRPC.ChannelOptions(credentials: creds); // TODO
    final channel = gRPC.ClientChannel(host, port: port, options: options);
    final conn = await channel.getConnection();
    return Connection._(conn, channel);
  }

  gRPC.ConnectionState get state => _conn.state;

  gRPC.ClientChannel get channel => _channel;

  Client get client => Client(this);

  Future<void> close() => _channel.shutdown();

  Future<void> abort() => _channel.terminate();

  Future<void> check() => client.ping();
}
