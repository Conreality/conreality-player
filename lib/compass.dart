/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

class CompassScreen extends StatefulWidget {
  CompassScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CompassState createState() => CompassState();
}

////////////////////////////////////////////////////////////////////////////////

class CompassState extends State<CompassScreen> {
  static const platform = MethodChannel('app.conreality.org/compass');

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: _ignore),
        ],
      ),
      body: Center(
        child: Text("Compass Screen"), // TODO
      ),
    );
  }

  void _ignore() {}
}
