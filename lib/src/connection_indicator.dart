/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as gRPC;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;

import 'connection.dart' show Connection;

////////////////////////////////////////////////////////////////////////////////

class ConnectionIndicator extends StatefulWidget {
  final Future<Connection> connection;

  ConnectionIndicator({Key key, this.connection}) : super(key: key);

  @override
  State<ConnectionIndicator> createState() => _ConnectionIndicatorState(connection: connection);
}

////////////////////////////////////////////////////////////////////////////////

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  final Future<Connection> connection;

  _ConnectionIndicatorState({this.connection});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<Connection>(
      future: connection,
      builder: (final BuildContext context, final AsyncSnapshot<Connection> snapshot) {
        Color color = Colors.green;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            color = snapshot.hasError ? Colors.red : _colorForRPC(snapshot.data.state);
            break;
          default:
            color = _colorForBuilder(snapshot.connectionState);
            break;
        }
        return Icon(MdiIcons.circleMedium, color: color);
      },
    );
  }

  Color _colorForBuilder(final ConnectionState state) {
    switch (state) {
      case ConnectionState.none:    // fall through
      case ConnectionState.active:  // fall through
      case ConnectionState.waiting: return Colors.orange;
      case ConnectionState.done:    return Colors.green;
    }
    assert(false, "unreachable");
    return null; // unreachable
  }

  Color _colorForRPC(final gRPC.ConnectionState state) {
    switch (state) {
      case gRPC.ConnectionState.idle:             return Colors.orange;
      case gRPC.ConnectionState.connecting:       return Colors.orange;
      case gRPC.ConnectionState.ready:            return Colors.green;
      case gRPC.ConnectionState.transientFailure: return Colors.deepOrange;
      case gRPC.ConnectionState.shutdown:         return Colors.red;
    }
    assert(false, "unreachable");
    return null; // unreachable
  }
}
