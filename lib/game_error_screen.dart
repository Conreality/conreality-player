/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'game.dart';
import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

class GameErrorScreen extends StatelessWidget {
  GameErrorScreen({this.game, this.error});

  final Game game;
  final Object error;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? Strings.connecting),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.retry.toUpperCase()),
            onPressed: () {
              // TODO
            },
          ),
          FlatButton(
            child: Text(Strings.cancel.toUpperCase()),
            onPressed: () => exitGame(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error, size: 192.0),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }
}
