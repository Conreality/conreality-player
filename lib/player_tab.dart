/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';

import 'player_status.dart' show PlayerStatus;

import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;
import 'src/spinner.dart' show Spinner;
import 'src/text_section.dart' show TextSection;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  final GameSession session;
  final int playerID;

  PlayerTab({Key key, @required this.session, this.playerID})
    : assert(session != null),
      super(key: key);

  @override
  State<PlayerTab> createState() => PlayerTabState();
}

////////////////////////////////////////////////////////////////////////////////

class PlayerTabState extends State<PlayerTab> {
  Player _player;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(final PlayerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    reload();
  }

  void reload() async {
    final GameSession session = widget.session;
    final Player player = await session.cache.getPlayer(widget.playerID ?? session.playerID);
    setState(() {
      _player = player;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return (_player == null) ? Spinner() : Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlayerInfo(player: _player), // fixed
          // TODO: status (ingame/outgame)
          // TODO: shot count
          Expanded(child: PlayerBio(player: _player)), // scrollable
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PlayerInfo extends StatelessWidget {
  final Player player;

  PlayerInfo({this.player});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle rankStyle = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color);
    return Row(
      children: <Widget>[
        Icon(Icons.person_outline, size: 160.0), // TODO: avatar
        SizedBox(width: 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(player?.nick != null ? player.nick : "", style: TextStyle(fontSize: 32.0)),
              padding: EdgeInsets.zero,
              alignment: Alignment.topLeft,
            ),
            Container(
              child: Text(player?.rank != null && player.rank.isNotEmpty ? player.rank : "", style: rankStyle),
              padding: EdgeInsets.only(top: 16.0),
              alignment: Alignment.topLeft,
            ),
            Container(
              child: PlayerStatus(player: player, isSelf: true),
              padding: EdgeInsets.only(top: 16.0),
              alignment: Alignment.topLeft,
            ),
            // TODO: nationality/language
          ],
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PlayerBio extends StatelessWidget {
  final Player player;

  PlayerBio({this.player});

  @override
  Widget build(final BuildContext context) {
    return ListView(
      children: <Widget>[
        TextSection(
          title: "Bio",
          subtitle: "",
          text: player.bio ?? "",
          language: player.language,
          initiallyExpanded: player.hasBio,
        ),
      ],
    );
  }
}
