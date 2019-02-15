/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;

import 'chat_tab.dart' show ChatTab;
import 'game_drawer.dart' show GameDrawer;
import 'game_tab.dart' show GameTab;
import 'keys.dart';
import 'map_tab.dart' show MapTab;
import 'player_tab.dart' show PlayerTab;
import 'share_screen.dart';
import 'team_tab.dart' show TeamTab;

import 'src/api.dart' as API;
import 'src/client.dart' show Client;
import 'src/config.dart' show Config;
import 'src/connection_indicator.dart' show ConnectionIndicator;
import 'src/game.dart' show exitGame, terminateApp;
import 'src/model.dart' show Game, GameAction, GameState;
import 'src/session.dart' show GameSession;
import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

enum GameMenuChoice { share, exit, terminate }

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  final GameSession session;

  GameScreen({Key key, @required this.session})
    : assert(session != null),
      super(key: key);

  @override
  State<GameScreen> createState() => GameScreenState(session);
}

////////////////////////////////////////////////////////////////////////////////

class GameScreenState extends State<GameScreen> {
  final List<Widget> _tabs;
  int _tabIndex = 0;

  GameScreenState(final GameSession session)
    : assert(session != null),
      _tabs = [
        PlayerTab(key: refreshMeTabKey, session: session),
        TeamTab(key: refreshTeamTabKey, session: session),
        GameTab(key: refreshGameTabKey, session: session),
        ChatTab(key: refreshChatTabKey, session: session),
        MapTab(key: refreshMapTabKey, session: session),
      ],
      super();

  void reload() {
    setState(() {});
  }

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
            ConnectionIndicator(connection: session.connection),
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
              PopupMenuItem<GameMenuChoice>(
                value: GameMenuChoice.terminate,
                child: Text("Terminate the app"),
              ),
            ],
          ),
        ],
      ),
      drawer: GameDrawer(),
      body: _tabs[_tabIndex],
      floatingActionButton: actionButton(_tabIndex),
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
            title: Text("Game"),
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

  FloatingActionButton actionButton(final int tabIndex) {
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
        final GameAction action = nextGameAction();
        return (action == null) ? null : FloatingActionButton(
          tooltip: null, // TODO
          child: Icon(getGameActionIcon(action)),
          onPressed: () => executeGameAction(action),
        );
      default: return null;
    }
  }

  GameAction nextGameAction() {
    final GameSession session = widget.session;
    switch (session.game.state) {
      case GameState.planned:
      case GameState.paused:
        return GameAction.begin;
      case GameState.begun:
      case GameState.resumed:
        return GameAction.pause;
      case GameState.ended:
        return null; // nothing to do
    }
    assert(false, "unreachable");
    return null; // unreachable
  }

  IconData getGameActionIcon(final GameAction action) {
    switch (action) {
      case GameAction.begin:
      case GameAction.resume:
        return MdiIcons.play;
      case GameAction.pause:
        return MdiIcons.pause;
      case GameAction.end:
        return MdiIcons.stop;
      default: // null
        return null;
    }
  }

  Future<void> executeGameAction(final GameAction action) async {
    final Client client = Client(widget.session.connection);
    switch (action) {
      case GameAction.begin:
      case GameAction.resume:
        await client.rpc.startGame(API.TextString());
        break;
      case GameAction.pause:
        await client.rpc.pauseGame(API.TextString());
        break;
      case GameAction.end:
        await client.rpc.stopGame(API.TextString());
        break;
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
      case GameMenuChoice.terminate:
        terminateApp(context);
        break;
    }
  }
}
