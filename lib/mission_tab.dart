/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'src/api.dart' as API;
import 'src/text_section.dart' show TextSection;

////////////////////////////////////////////////////////////////////////////////

class MissionTab extends StatefulWidget {
  MissionTab({Key key, this.info}) : super(key: key);

  final API.GameInformation info;

  @override
  State<MissionTab> createState() => MissionState();
}
////////////////////////////////////////////////////////////////////////////////

class MissionState extends State<MissionTab> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GameState(game: widget.info), // fixed
          Expanded(child: GameDescription(game: widget.info)), // scrollable
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends StatelessWidget {
  final API.GameInformation game;

  GameState({this.game});

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Text("Game not started yet", style: TextStyle(fontSize: 32.0)), // TODO: game state
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameDescription extends StatelessWidget {
  final API.GameInformation game;

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
