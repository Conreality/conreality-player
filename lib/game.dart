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
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? "?"),
        actions: <Widget>[
          PopupMenuButton<GameMenuChoice>(
            onSelected: _onMenuAction,
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<GameMenuChoice>>[
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.exit,
                child: Text(Strings.exitGame),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<API.HelloResponse>(
        future: _hello(),
        builder: (final BuildContext context, final AsyncSnapshot<API.HelloResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: 300.0,
                )
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              final API.HelloResponse response = snapshot.data; // TODO: response.list
              return Text(response.name);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
    );
  }

  void _onMenuAction(final GameMenuChoice choice) {
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

  Future<Null> _disconnect() async {
    return _client.disconnect();
  }

  Future<API.HelloResponse> _hello() async {
    return _client.hello("0.0.0");
  }
}
