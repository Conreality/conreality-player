/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api.dart' as API;
import 'config.dart';
import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

void exitGame(final BuildContext context) async {
  Config.load()
    .then((final Config config) => config.setCurrentGame(null))
    .then((_) => Navigator.of(context).pushReplacementNamed('/'));
}

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
    return _client.hello("0.0.0"); // TODO
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameLoadingScreen extends StatelessWidget {
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

  void _onMenuAction(final BuildContext context, final GameMenuChoice choice) {
    switch (choice) {
      case GameMenuChoice.exit:
        exitGame(context);
        break;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameOverviewScreen extends StatefulWidget {
  GameOverviewScreen({this.info});

  final API.GameInformation info;

  @override
  GameOverviewState createState() => GameOverviewState();
}

class GameOverviewState extends State<GameOverviewScreen> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.name ?? ""),
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
      drawer: GameDrawer(),
      body: Center(
        child: SpinKitWave(
          color: Colors.grey,
          size: 100.0,
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Stats"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(Strings.team),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(Strings.chat),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            title: Text(Strings.compass),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(Strings.map),
          ),
        ],
      ),
    );
  }

  void _onMenuAction(final BuildContext context, final GameMenuChoice choice) {
    switch (choice) {
      case GameMenuChoice.exit:
        exitGame(context);
        break;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameDrawer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[
      Divider(),

      ListTile(
        leading: Icon(Icons.contacts),
        title: Text(Strings.team),
        onTap: () {
          Navigator.of(context).pushNamed('/team');
        },
      ),

      ListTile(
        leading: Icon(Icons.chat),
        title: Text(Strings.chat),
        onTap: () {
          Navigator.of(context).pushNamed('/chat');
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text(Strings.compass),
        onTap: () {
          Navigator.of(context).pushNamed('/compass');
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text(Strings.map),
        onTap: () {
          Navigator.of(context).pushNamed('/map');
        },
      ),

      Divider(),

      ListTile(
        leading: Icon(Icons.report),
        title: Text(Strings.sendFeedback),
        onTap: () {
          launch(Strings.feedbackURL);
        },
      ),

      AboutListTile(
        icon: FlutterLogo(), // TODO
        applicationVersion: Strings.appVersion,
        applicationIcon: FlutterLogo(), // TODO
        applicationLegalese: Strings.legalese,
        aboutBoxChildren: <Widget>[],
      ),
    ];
    return Drawer(child: ListView(primary: false, children: allDrawerItems));
  }
}
