/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'game.dart';
import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class GameLoadingScreen extends StatelessWidget {
  GameLoadingScreen({this.game});

  final Game game;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? Strings.of(context).loading),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.of(context).cancel.toUpperCase()),
            onPressed: () => exitGame(context),
          ),
        ],
      ),
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.grey,
          size: 300.0,
        ),
      ),
    );
  }
}
