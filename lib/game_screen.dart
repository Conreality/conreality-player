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
import 'strings.dart';
import 'team_tab.dart';

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({this.game, this.info});

  final Game game;
  final API.GameInformation info;

  @override
  GameState createState() => GameState();
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  API.Client _client;
  int _tabIndex = 0;
  final List<Widget> _tabs = [
    HomeTab(),
    TeamTab(),
    ChatTab(),
    CompassTab(),
    MapTab(),
  ];

  @override
  void initState() {
    super.initState();
    _client = API.Client(widget.game);
  }

  @override
  Future<Null> dispose() async {
    super.dispose();
    return _client.disconnect();
  }

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
      body: _tabs[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(Strings.home),
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
