/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;

import 'chat_tab.dart';
import 'game_drawer.dart';
import 'keys.dart';
import 'map_tab.dart';
import 'mission_tab.dart';
import 'player_tab.dart';
import 'share_screen.dart';
import 'team_tab.dart';

import 'src/config.dart' show Config;
import 'src/connection_indicator.dart' show ConnectionIndicator;
import 'src/game.dart' show exitGame;
import 'src/model.dart' show Game;
import 'src/session.dart' show GameSession;
import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

enum GameMenuChoice { share, exit }

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  final GameSession session;

  GameScreen({@required this.session})
    : assert(session != null);

  @override
  State<GameScreen> createState() => GameState(session);
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  final List<Widget> _tabs;
  int _tabIndex = 0;

  GameState(final GameSession session)
    : assert(session != null),
      _tabs = [
        PlayerTab(key: refreshMeKey, session: session),
        TeamTab(key: refreshTeamKey, session: session),
        MissionTab(key: refreshGameKey, session: session),
        ChatTab(key: refreshChatKey, session: session),
        MapTab(key: refreshMapKey, session: session),
      ],
      super();

  @override
  Future<void> dispose() async {
    super.dispose();
    final GameSession session = widget.session;
    await session.connection.close();
  }

  @override
  Widget build(final BuildContext context) {
    final GameSession session = widget.session;
    final Game game = session.game;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(game.title ?? "(Unnamed game)"),
            SizedBox(width: 8),
            ConnectionIndicator(connection: Future.value(session.connection)),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<GameMenuChoice>(
            onSelected: (final GameMenuChoice choice) => _onMenuAction(context, choice),
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<GameMenuChoice>>[
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.share,
                child: Text("Share game URL..."), // TODO: Text(Strings.of(context).share
              ),
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
      floatingActionButton: addButton(_tabIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Me"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(Strings.of(context).team),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games), // TODO: better icon?
            title: Text("Mission"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(Strings.of(context).chat),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(Strings.of(context).map),
          ),
        ],
      ),
    );
  }

  FloatingActionButton addButton(final int tabIndex) {
    switch (tabIndex) {
      case 0: return null; // Me TODO
      case 1: // Team
        return FloatingActionButton(
          tooltip: "Add",
          child: Icon(Icons.add),
          /*onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (final BuildContext context) => null, // TODO
              fullscreenDialog: true,
            ));
          },*/
        );
      case 2: // Game
        return FloatingActionButton(
          tooltip: "Start",
          child: Icon(MdiIcons.clockStart),
          /*onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (final BuildContext context) => null, // TODO
              fullscreenDialog: true,
            ));
          },*/
        );
      default: return null;
    }
  }

  void _onTabTapped(final int index) {
    setState(() { _tabIndex = index; });
  }

  void _onMenuAction(final BuildContext context, final GameMenuChoice choice) {
    switch (choice) {
      case GameMenuChoice.share:
        Config.load()
          .then((final Config config) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (final BuildContext context) {
                  return ShareScreen(gameURL: config.getCurrentGameURL() ?? Config.DEFAULT_URL);
                }
              )
            );
          });
        break;
      case GameMenuChoice.exit:
        exitGame(context);
        break;
    }
  }
}
