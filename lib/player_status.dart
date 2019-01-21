/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'cache.dart' show Player;

////////////////////////////////////////////////////////////////////////////////

class PlayerStatus extends StatelessWidget {
  final Player player;

  PlayerStatus({Key key, this.player}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Icon(player?.headset == true ? MdiIcons.headset : MdiIcons.headsetOff, color: Colors.white70, size: 16.0),
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.topLeft,
        ),
        Container(
          child: Icon(MdiIcons.heartPulse, color: player?.heartrate != null ? Colors.red : Colors.white70, size: 16.0),
          padding: EdgeInsets.only(left: 8.0),
          alignment: Alignment.topLeft,
        ),
        Container(
          child: Text((player?.heartrate ?? "N/A").toString()),
          padding: EdgeInsets.only(left: 4.0),
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
    );
  }
}
