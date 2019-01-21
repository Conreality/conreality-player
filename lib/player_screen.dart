/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'cache.dart' show Player;
import 'player_tab.dart';

////////////////////////////////////////////////////////////////////////////////

class PlayerScreen extends StatelessWidget {
  final Player player;

  PlayerScreen({Key key, this.player}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.nick),
        actions: <Widget>[],
      ),
      body: PlayerTab(player: player),
    );
  }
}
