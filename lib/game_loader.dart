/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';

import 'game_loading_screen.dart';
import 'game_error_screen.dart';
import 'game_screen.dart';
import 'load.dart' show load;

import 'src/api.dart' as API;
import 'src/game.dart' show Game;

////////////////////////////////////////////////////////////////////////////////

class GameLoader extends StatefulWidget {
  GameLoader({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  State<GameLoader> createState() => GameLoaderState();
}

////////////////////////////////////////////////////////////////////////////////

class GameLoaderState extends State<GameLoader> {
  Future<API.GameInformation> _response;

  @override
  void initState() {
    super.initState();
    _response = Future.sync(() => load());
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    return FutureBuilder<API.GameInformation>(
      future: _response,
      builder: (final BuildContext context, final AsyncSnapshot<API.GameInformation> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return GameLoadingScreen(game: game);
          case ConnectionState.done:
            return (snapshot.hasError) ?
              GameErrorScreen(game: game, error: snapshot.error) :
              GameScreen(game: game, info: snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}
