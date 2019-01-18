/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart' as API;
import 'chat_tab.dart';
import 'compass_tab.dart';
import 'game.dart';
import 'game_drawer.dart';
import 'home_tab.dart';
import 'map_tab.dart';
import 'share_tab.dart';
import 'team_tab.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({this.game, this.info});

  final Game game;
  //final API.GameInformation info; // FIXME
  final Object info;

  @override
  GameState createState() => GameState(game, API.Client(game));
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  final API.Client _client;
  final List<Widget> _tabs;
  int _tabIndex = 0;

  GameState(final Game game, final API.Client client)
    : _client = client,
      _tabs = [
        HomeTab(),
        ShareTab(gameURL: game.url.toString()),
        TeamTab(),
        ChatTab(client: client),
        CompassTab(),
        MapTab(),
      ],
      super();

  @override
  Future<void> dispose() async {
    super.dispose();
    return _client.disconnect();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.info.name ?? ""), // FIXME
        title: Text("TODO"),
        actions: <Widget>[
          PopupMenuButton<GameMenuChoice>(
            onSelected: (final GameMenuChoice choice) => _onMenuAction(context, choice),
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<GameMenuChoice>>[
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.exit,
                child: Text(Strings.of(context).exitGame),
              ),
            ],
          ),
        ],
      ),
      drawer: GameDrawer(),
      body: _tabs[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(Strings.of(context).home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            title: Text(Strings.of(context).share),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(Strings.of(context).team),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(Strings.of(context).chat),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            title: Text(Strings.of(context).compass),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(Strings.of(context).map),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(final int index) {
    setState(() { _tabIndex = index; });
  }

  void _onMenuAction(final BuildContext context, final GameMenuChoice choice) {
    switch (choice) {
      case GameMenuChoice.exit:
        exitGame(context);
        break;
    }
  }
}
