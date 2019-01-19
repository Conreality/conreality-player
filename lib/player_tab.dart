/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  PlayerTab({Key key, this.info}) : super(key: key);

  final API.GameInformation info;

  @override
  State<PlayerTab> createState() => PlayerState();
}
////////////////////////////////////////////////////////////////////////////////

class PlayerState extends State<PlayerTab> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Center(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(Icons.person_outline, size: 160.0),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("Player Name", style: TextStyle(fontSize: 32.0)), // TODO: nick
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  child: Text("Private"), // TODO: rank
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.topLeft,
                ),
                // TODO: status (ingame/outgame)
                // TODO: heart beat
                // TODO: shot count
                // TODO: nationality/language
              ],
            ),
          ],
        ),
      ),
    );
  }
}
