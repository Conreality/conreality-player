/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';

import 'game_loading_screen.dart';
import 'game_error_screen.dart';
import 'game_screen.dart';
import 'load.dart' show loadGame;

import 'src/api.dart' as API;
import 'src/game.dart' show Game;
import 'src/model.dart' show Player;

////////////////////////////////////////////////////////////////////////////////

class GameLoader extends StatefulWidget {
  GameLoader({Key key, this.game, this.player}) : super(key: key);

  final Game game;
  final Player player;

  @override
  State<GameLoader> createState() => _GameLoaderState();
}

////////////////////////////////////////////////////////////////////////////////

class _GameLoaderState extends State<GameLoader> {
  Future<API.GameInformation> _response;

  @override
  void initState() {
    super.initState();
    _response = Future.sync(() => loadGame());
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    final player = widget.player;
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
              GameScreen(game: game, player: player, info: snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}
