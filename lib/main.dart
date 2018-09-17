/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'game.dart';
import 'start.dart';

void main() => runApp(App());

////////////////////////////////////////////////////////////////////////////////

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

////////////////////////////////////////////////////////////////////////////////

class AppState extends State<App> {
  Future<Game> _game;

  @override
  initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Conreality Player',
      color: Colors.grey,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: FutureBuilder<Game>(
        future: _game,
        builder: (final BuildContext context, final AsyncSnapshot<Game> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return AppLoading();
            case ConnectionState.done:
              final Game game = snapshot.data;
              if (snapshot.hasError || game == null) {
                return StartScreen(title: 'Conreality Player');
              }
              return GameScreen(game: game);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
    );
  }

  void _load() async {
    final Config config = await Config.load();
    await config.clear(); // DEBUG
    setState(() {
      final bool hasGame = config.hasKey("game.url");
      _game = Future.value(!hasGame ? null :
        Game(
          url:   Uri.tryParse(config.getString("game.url")),
          uuid:  config.getString("game.uuid"),
          title: config.getString("game.title"),
        )
      );
    });
  }
}

////////////////////////////////////////////////////////////////////////////////

class AppLoading extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return SpinKitPulse(
      color: Colors.grey,
      size: 300.0,
    );
  }
}
