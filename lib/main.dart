/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chat_screen.dart';
import 'config.dart';
import 'compass_screen.dart';
import 'game.dart';
import 'game_loader.dart';
import 'map_screen.dart';
import 'scan_screen.dart';
import 'strings.dart';

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
      title: Strings.appTitle,
      color: Colors.grey,
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
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
                return ScanScreen(title: Strings.appTitle);
              }
              return GameLoader(game: game);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
      routes: {
        '/chat': (context) => ChatScreen(title: "Demo Chat"),
        '/compass': (context) => CompassScreen(title: "Demo Compass"),
        //'/game': (context) => GameScreen(game: game), // TODO
        '/map': (context) => MapScreen(title: "Demo Map"),
        '/scan': (context) => ScanScreen(title: Strings.appTitle),
        //'/team': (context) => TeamScreen(), // tODO
      },
    );
  }

  void _load() async {
    final Config config = await Config.load();
    //await config.clear(); // DEBUG
    setState(() {
      final bool hasGame = config.hasKey('game.url');
      _game = Future.value(!hasGame ? null :
        Game(
          url:   Uri.tryParse(config.getString('game.url')),
          uuid:  config.getString('game.uuid'),
          title: config.getString('game.title'),
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
