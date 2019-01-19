/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  PlayerTab({Key key, this.player}) : super(key: key);

  final API.Player player;

  @override
  State<PlayerTab> createState() => PlayerState();
}
////////////////////////////////////////////////////////////////////////////////

class PlayerState extends State<PlayerTab> {
  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final API.Player player = widget.player;
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
                  child: Text(player != null && player.nick != null ? player.nick : "Player Name", style: TextStyle(fontSize: 32.0)),
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  child: Text(player != null && player.rank != null && player.rank.isNotEmpty ? player.rank : "No rank", style: theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color)),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.topLeft,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Icon(MdiIcons.headset, color: Colors.white),
                      padding: EdgeInsets.all(16.0), // TODO: RHS should be 8.0
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Icon(MdiIcons.heartPulse, color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Text("42"),
                      padding: EdgeInsets.all(4.0),
                      alignment: Alignment.topLeft,
                    ),
                  ],
                )
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
