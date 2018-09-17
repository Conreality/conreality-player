/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

////////////////////////////////////////////////////////////////////////////////

class Game {
  Game({this.url, this.uuid, this.title});

  final String url;

  final String uuid;

  final String title;
}

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  GameState createState() => GameState();
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  static const platform = MethodChannel('app.conreality.org/game');

  @override
  Widget build(final BuildContext context) {
    final Game game = widget.game;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? "?"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: _ignore),
        ],
      ),
      body: Center(
        child: Text('Game Screen'), // TODO
      ),
    );
  }

  void _ignore() {}
}
