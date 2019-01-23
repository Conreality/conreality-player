/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'cache.dart' show Player;
import 'player_status.dart' show PlayerStatus;

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
    final Player player = widget.player;
    return Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlayerInfo(player: player), // fixed
          Expanded(child: PlayerBio(player: player)), // scrollable
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
              child: Text(player?.nick != null ? player.nick : "Player Name", style: TextStyle(fontSize: 32.0)),
              padding: EdgeInsets.zero,
              alignment: Alignment.topLeft,
            ),
            Container(
              child: Text(player?.rank != null && player.rank.isNotEmpty ? player.rank : "No rank", style: rankStyle),
              padding: EdgeInsets.only(top: 16.0),
              alignment: Alignment.topLeft,
            ),
            Container(
              child: PlayerStatus(player: player),
              padding: EdgeInsets.only(top: 16.0),
              alignment: Alignment.topLeft,
            ),
            // TODO: status (ingame/outgame)
            // TODO: shot count
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
        ExpansionTile(
          title: Text("Bio", overflow: TextOverflow.ellipsis),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          initiallyExpanded: true,
          children: <Widget>[
            Container( // TODO: bio
              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vel pulvinar lacus. Donec id ligula dolor. Ut ac vestibulum massa. Integer nec nulla pellentesque eros sollicitudin ullamcorper."),
              padding: EdgeInsets.all(16.0),
            ),
            Container(padding: EdgeInsets.only(bottom: 16.0)),
          ],
        ),
      ],
    );
  }
}
