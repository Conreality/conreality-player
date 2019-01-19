/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'api.dart' as API;

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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Game not started yet", style: TextStyle(fontSize: 32.0)), // TODO: game state
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
            ),
            ExpansionTile(
              title: Text("Mission", overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              initiallyExpanded: true,
              children: <Widget>[
                ListTile(
                  title: Text(widget.info.title),
                  subtitle: Text(widget.info.mission),
                ),
                Container(padding: EdgeInsets.only(bottom: 16.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
