/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart' as API;
import 'game.dart';
import 'game_loading_screen.dart';
import 'game_error_screen.dart';
import 'game_screen.dart';

////////////////////////////////////////////////////////////////////////////////

class GameLoader extends StatefulWidget {
  GameLoader({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  GameLoaderState createState() => GameLoaderState();
}

////////////////////////////////////////////////////////////////////////////////

class GameLoaderState extends State<GameLoader> {
  Future<API.HelloResponse> _response;

  @override
  void initState() {
    super.initState();
    var client = API.Client(widget.game);
    _response = Future.sync(() => client.helloSimple("0.0.0")) // TODO: version
      .whenComplete(client.disconnect);
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    return FutureBuilder<API.HelloResponse>(
      future: _response,
      builder: (final BuildContext context, final AsyncSnapshot<API.HelloResponse> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return GameLoadingScreen(game: game);
          case ConnectionState.done:
            return (snapshot.hasError) ?
              GameErrorScreen(game: game, error: snapshot.error) :
              GameScreen(game: game, info: snapshot.data.game);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}
