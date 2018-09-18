/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'api.dart' as API;
import 'config.dart';
import 'start.dart';
import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

class Game {
  Game({this.url, this.uuid, this.title});

  final Uri url;

  final String uuid;

  final String title;

  String host() => url.host;

  int port() => url.hasPort ? url.port : Config.DEFAULT_PORT;
}

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  GameState createState() => GameState();
}

////////////////////////////////////////////////////////////////////////////////

enum GameMenuChoice { exit }

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  static const platform = MethodChannel('app.conreality.org/game');

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
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            final API.HelloResponse response = snapshot.data; // TODO: response.list
            return GameOverviewScreen(info: response.game);
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
    return _client.hello("0.0.0");
  }
}

////////////////////////////////////////////////////////////////////////////////

abstract class AbstractGameScreen extends StatelessWidget {
  void _onMenuAction(final BuildContext context, final GameMenuChoice choice) {
    switch (choice) {
      case GameMenuChoice.exit:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (final BuildContext context) {
              return StartScreen(title: Strings.appTitle);
            }
          )
        );
        break;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameLoadingScreen extends AbstractGameScreen {
  GameLoadingScreen({this.game});

  final Game game;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? ""),
        actions: <Widget>[
          PopupMenuButton<GameMenuChoice>(
            onSelected: (final GameMenuChoice choice) => _onMenuAction(context, choice),
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<GameMenuChoice>>[
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.exit,
                child: Text(Strings.exitGame),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.grey,
          size: 300.0,
        )
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameOverviewScreen extends AbstractGameScreen {
  GameOverviewScreen({this.info});

  final API.GameInformation info;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info.name),
        actions: <Widget>[
          PopupMenuButton<GameMenuChoice>(
            onSelected: (final GameMenuChoice choice) => _onMenuAction(context, choice),
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<GameMenuChoice>>[
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.exit,
                child: Text(Strings.exitGame),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SpinKitWave(
          color: Colors.grey,
          size: 100.0,
        )
      ),
    );
  }
}
