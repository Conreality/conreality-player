/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'cache.dart' show Player;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  PlayerTab({Key key, this.player}) : super(key: key);

  final Player player;

  @override
  State<PlayerTab> createState() => PlayerState();
}
////////////////////////////////////////////////////////////////////////////////

class PlayerState extends State<PlayerTab> {
  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Player player = widget.player;
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
                  child: Text(player?.nick != null ? player.nick : "Player Name", style: TextStyle(fontSize: 32.0)),
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  child: Text(player?.rank != null && player.rank.isNotEmpty ? player.rank : "No rank", style: theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color)),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.topLeft,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Icon(player?.headset == true ? MdiIcons.headset : MdiIcons.headsetOff, color: Colors.white70, size: 16.0),
                      padding: EdgeInsets.all(16.0), // TODO: RHS should be 8.0
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Icon(MdiIcons.heartPulse, color: player?.heartrate != null ? Colors.red : Colors.white70, size: 16.0),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Text((player?.heartrate ?? "N/A").toString()),
                      padding: EdgeInsets.all(4.0),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Icon(MdiIcons.walk, color: Colors.white70, size: 16.0),
                      padding: EdgeInsets.only(left: 8.0),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      child: Text(player?.distance != null ? "${player.distance.toInt()}m" : "N/A"),
                      padding: EdgeInsets.only(left: 4.0),
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
