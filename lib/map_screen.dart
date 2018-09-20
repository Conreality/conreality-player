/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'map_tab.dart';

////////////////////////////////////////////////////////////////////////////////

class MapScreen extends StatelessWidget {
  MapScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
        ],
      ),
      body: MapTab(),
    );
  }
}
