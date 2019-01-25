/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'player_tab.dart';

import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;

////////////////////////////////////////////////////////////////////////////////

class PlayerScreen extends StatelessWidget {
  final GameSession session;
  final Player player;

  PlayerScreen({Key key, @required this.session, this.player})
    : assert(session != null),
      super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.nick),
        actions: <Widget>[],
      ),
      body: PlayerTab(session: session, playerID: player.id),
    );
  }
}
