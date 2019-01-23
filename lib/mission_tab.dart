/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'api.dart' as API;
import 'speech.dart' show say;

////////////////////////////////////////////////////////////////////////////////

class MissionTab extends StatefulWidget {
  MissionTab({Key key, this.client, this.info}) : super(key: key);

  final API.Client client;
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
        ExpansionTile(
          title: Text("Mission", overflow: TextOverflow.ellipsis),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          initiallyExpanded: true,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(game.title ?? ""),
                    subtitle: Text(game.mission ?? ""),
                  ),
                ),
                Column(
                  children: (game.mission == null) ? <Widget>[] : <Widget>[
                    GestureDetector(
                      child: Icon(MdiIcons.playCircleOutline, color: Theme.of(context).disabledColor),
                      onTap: () async => await say(game.mission),
                    ),
                  ],
                ),
                Container(padding: EdgeInsets.only(right: 16.0)),
              ],
            ),
            Container(padding: EdgeInsets.only(bottom: 16.0)),
          ],
        ),
        ExpansionTile(
          title: Text("Rules", overflow: TextOverflow.ellipsis),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          initiallyExpanded: false,
          children: <Widget>[
            // TODO: list of rules
            Container(padding: EdgeInsets.only(bottom: 16.0)),
          ],
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
