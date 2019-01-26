/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'session.dart' show GameSession;

////////////////////////////////////////////////////////////////////////////////

class PlayerAvatar extends StatelessWidget {
  final GameSession session;
  final int playerID;

  PlayerAvatar({Key key, @required this.session, @required this.playerID})
    : assert(session != null),
      assert(playerID != null),
      super(key: key);

  @override
  Widget build(final BuildContext context) {
    // TODO: use player.avatar, if available
    final String playerNick = session.cache.getName(playerID);
    final Color playerColor = session.cache.getColor(playerID);
    return CircleAvatar(
      child: Text(playerNick.substring(0, 1)),
      backgroundColor: playerColor,
    );
  }
}
