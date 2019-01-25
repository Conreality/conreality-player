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
          title: "Summary",
          subtitle: game.title, // TODO: link
          text: game.summary,
          language: game.language,
          initiallyExpanded: true,
        ),
        TextSection(
          title: "Theater", // TODO: origin, radius/bounds, address, map?
          subtitle: game.address,
          text: game.theater,
          language: game.language,
          initiallyExpanded: false,
        ),
        TextSection(
          title: "Rules",
          subtitle: null,
          text: game.rules, // TODO: list of rules
          language: game.language,
          initiallyExpanded: false,
        ),
        TextSection(
          title: "Schedule",
          subtitle: null,
          text: game.schedule, // TODO: list of schedule entries
          language: game.language,
          initiallyExpanded: false,
        ),
      ],
    );
  }
}
