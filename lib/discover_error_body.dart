/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////

class DiscoverErrorBody extends StatelessWidget {
  DiscoverErrorBody({this.error});

  final Object error;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.signal_wifi_off, size: 192.0),
          Text(error.toString()),
        ],
      ),
    );
  }
}
