/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'player_tab.dart';

import 'src/cache.dart' show Player;

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
