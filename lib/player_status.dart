/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;

////////////////////////////////////////////////////////////////////////////////

class PlayerStatus extends StatelessWidget {
  final GameSession session;
  final Player player;
  final bool isSelf;
  final bool showConnectivity;

  PlayerStatus({Key key, @required this.session, this.player, this.isSelf = false, this.showConnectivity = true}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final heartRate = (isSelf ? session.cache.playerHeartRate : player?.heartrate);
    return Row(
      children: <Widget>[
        !showConnectivity ? null : Container(
          child: Icon(MdiIcons.circleMedium, color: _statusColor, size: 16.0),
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.topLeft,
        ),
        Container(
          child: Icon(player?.headset == true ? MdiIcons.headset : MdiIcons.headsetOff, color: Colors.white70, size: 16.0),
          padding: !showConnectivity ? EdgeInsets.all(0.0) : EdgeInsets.only(left: 4.0),
          alignment: Alignment.topLeft,
        ),
        Container(
          child: Icon(MdiIcons.heartPulse, color: heartRate != null ? Colors.red : Colors.white70, size: 16.0),
          padding: EdgeInsets.only(left: 8.0),
          alignment: Alignment.topLeft,
        ),
        Container(
          child: Text((heartRate ?? "N/A").toString()),
          padding: EdgeInsets.only(left: 4.0),
          alignment: Alignment.topLeft,
        ),
        isSelf ? null : Container(
          child: Icon(MdiIcons.walk, color: Colors.white70, size: 16.0),
          padding: EdgeInsets.only(left: 8.0),
          alignment: Alignment.topLeft,
        ),
        isSelf ? null : Container(
          child: Text(player?.distance != null ? "${player.distance.toInt()}m" : "N/A"),
          padding: EdgeInsets.only(left: 4.0),
          alignment: Alignment.topLeft,
        ),
      ].where((element) => element != null).toList(),
    );
  }

  Color get _statusColor {
    if (isSelf) return session.connection.color;
    final DateTime last = player.timestamp;
    if (last == null) return Colors.grey[600];
    final DateTime now = DateTime.now().toUtc();
    final int elapsedSeconds = now.difference(last).inSeconds;
    if (elapsedSeconds > 3600) return Colors.grey[600];
    if (elapsedSeconds > 300) return Colors.red;
    if (elapsedSeconds > 60) return Colors.deepOrange;
    if (elapsedSeconds > 30) return Colors.orange;
    if (elapsedSeconds > 10) return Colors.yellow;
    return Colors.green;
  }
}
