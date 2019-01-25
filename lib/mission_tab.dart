/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'src/model.dart';
import 'src/session.dart' show GameSession;
import 'src/text_section.dart' show TextSection;

////////////////////////////////////////////////////////////////////////////////

class MissionTab extends StatefulWidget {
  final GameSession session;

  MissionTab({Key key, @required this.session})
    : assert(session != null),
      super(key: key);

  @override
  State<MissionTab> createState() => MissionState();
}
////////////////////////////////////////////////////////////////////////////////

class MissionState extends State<MissionTab> {
  void reload() {
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.session.game;
    return Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GameStatus(game: game), // fixed
          Expanded(child: GameDescription(game: game)), // scrollable
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameStatus extends StatelessWidget {
  final Game game;

  GameStatus({this.game});

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Text(_gameState(), style: TextStyle(fontSize: 32.0)),
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
    );
  }

  String _gameState() {
    switch (game.state) {
      case GameState.planned: return "Game planned";
      case GameState.begun:   return "Game begun";
      case GameState.paused:  return "Game paused";
      case GameState.resumed: return "Game resumed";
      case GameState.ended:   return "Game ended";
      default: return "";
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameDescription extends StatelessWidget {
  final Game game;

  GameDescription({this.game});

  @override
  Widget build(final BuildContext context) {
    return ListView(
      children: <Widget>[
        TextSection(
          title: "Mission",
          subtitle: game.title,
          text: game.mission,
          initiallyExpanded: true,
        ),
        TextSection(
          title: "Rules",
          subtitle: null,
          text: "", // TODO: list of rules
          initiallyExpanded: false,
        ),
        ExpansionTile(
          title: Text("Theater", overflow: TextOverflow.ellipsis),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          initiallyExpanded: false,
          children: <Widget>[
            // TODO: origin, bounds, address, map?
            Container(padding: EdgeInsets.only(bottom: 16.0)),
          ],
        ),
      ],
    );
  }
}
