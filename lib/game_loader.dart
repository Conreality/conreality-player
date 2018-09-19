/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  API.Client _client;

  @override
  void initState() {
    super.initState();
    _client = API.Client(widget.game);
  }

  @override
  void dispose() async {
    super.dispose();
    await _disconnect();
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    return FutureBuilder<API.HelloResponse>(
      future: _hello(),
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

  Future<Null> _disconnect() async {
    return _client.disconnect();
  }

  Future<API.HelloResponse> _hello() async {
    return _client.hello("0.0.0"); // TODO
  }
}
