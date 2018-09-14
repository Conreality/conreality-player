/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GameState createState() => GameState();
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  static const platform = MethodChannel('app.conreality.org/game');

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
