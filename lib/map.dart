/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

////////////////////////////////////////////////////////////////////////////////

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MapState createState() => MapState();
}

////////////////////////////////////////////////////////////////////////////////

class MapState extends State<MapScreen> {
  static const platform = MethodChannel('app.conreality.org/map');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: _ignore),
        ],
      ),
      body: Center(
        child: Text('To be implemented.'), // TODO
      ),
    );
  }

  void _ignore() {}
}
