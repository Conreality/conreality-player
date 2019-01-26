/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'player_tab.dart';

import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;

////////////////////////////////////////////////////////////////////////////////

class PlayerScreen extends StatefulWidget {
  final GameSession session;
  final int playerID;

  PlayerScreen({Key key, @required this.session, this.playerID})
    : assert(session != null),
      super(key: key);

  @override
  State<PlayerScreen> createState() => PlayerScreenState();
}

////////////////////////////////////////////////////////////////////////////////

class PlayerScreenState extends State<PlayerScreen> {
  Player _player;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() async {
    final GameSession session = widget.session;
    final Player player = await session.cache.getPlayer(widget.playerID);
    setState(() {
      _player = player;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_player?.nick ?? "Loading..."),
        actions: <Widget>[],
      ),
      body: PlayerTab(session: widget.session, playerID: widget.playerID),
    );
  }
}
