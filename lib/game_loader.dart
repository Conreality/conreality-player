/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';

import 'game_loading_screen.dart';
import 'game_error_screen.dart';
import 'game_screen.dart';
import 'keys.dart' show refreshGameScreenKey;
import 'load.dart' show loadGame;

import 'src/session.dart' show GameSession;

////////////////////////////////////////////////////////////////////////////////

class GameLoader extends StatefulWidget {
  GameLoader({Key key, this.gameURL}) : super(key: key);

  final Uri gameURL;

  @override
  State<GameLoader> createState() => _GameLoaderState();
}

////////////////////////////////////////////////////////////////////////////////

class _GameLoaderState extends State<GameLoader> {
  Future<GameSession> _session;

  @override
  void initState() {
    super.initState();
    _session = Future.sync(() => loadGame(widget.gameURL));
  }

  @override
  Widget build(final BuildContext context) {
    final Uri gameURL = widget.gameURL;
    return FutureBuilder<GameSession>(
      future: _session,
      builder: (final BuildContext context, final AsyncSnapshot<GameSession> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return GameLoadingScreen(gameURL: gameURL);
          case ConnectionState.done:
            return (snapshot.hasError) ?
              GameErrorScreen(error: snapshot.error) :
              GameScreen(key: refreshGameScreenKey, session: snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}
