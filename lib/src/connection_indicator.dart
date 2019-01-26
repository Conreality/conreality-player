/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;

import 'connection.dart' show Connection;

////////////////////////////////////////////////////////////////////////////////

class ConnectionIndicator extends StatefulWidget {
  final Connection connection;

  ConnectionIndicator({Key key, @required this.connection})
    : assert(connection != null),
      super(key: key);

  @override
  State<ConnectionIndicator> createState() => _ConnectionIndicatorState();
}

////////////////////////////////////////////////////////////////////////////////

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(final BuildContext context) {
    final Connection connection = widget.connection;
    return Icon(MdiIcons.circleMedium, color: connection?.color ?? Colors.grey[600]);
  }
}
