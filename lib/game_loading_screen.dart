/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'src/game.dart' show exitGame;
import 'src/spinner.dart' show Spinner;
import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

class GameLoadingScreen extends StatelessWidget {
  final Uri gameURL;

  GameLoadingScreen({this.gameURL});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).loading),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.of(context).cancel.toUpperCase()),
            onPressed: () => exitGame(context),
          ),
        ],
      ),
      body: Spinner(),
    );
  }
}
