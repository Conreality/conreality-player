/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';

import 'player_status.dart' show PlayerStatus;

import 'src/cache.dart' show Cache;
import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;
import 'src/spinner.dart' show Spinner;
import 'src/text_section.dart' show TextSection;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  final GameSession session;
  final int playerID;

  PlayerTab({Key key, this.session, this.playerID}) : super(key: key);

  @override
  State<PlayerTab> createState() => PlayerState();
}

////////////////////////////////////////////////////////////////////////////////

class PlayerState extends State<PlayerTab> {
  Future<Player> _player;
  Cache _cache;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {
      _player = Future.sync(() => _load());
    });
  }

  Future<Player> _load() async {
    if (_cache == null) {
      _cache = await Cache.instance;
    }
    return _cache.getPlayer(widget.playerID);
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<Player>(
      future: _player,
      builder: (final BuildContext context, final AsyncSnapshot<Player> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Spinner();
          case ConnectionState.done:
            if (snapshot.hasError) return Text(snapshot.error.toString()); // GrpcError
            return PlayerPage(player: snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PlayerPage extends StatelessWidget {
  final Player player;

  PlayerPage({this.player});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlayerInfo(player: player), // fixed
          // TODO: status (ingame/outgame)
          // TODO: shot count
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
        TextSection( // TODO: bio
          title: "Bio",
          subtitle: "",
          text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vel pulvinar lacus. Donec id ligula dolor. Ut ac vestibulum massa. Integer nec nulla pellentesque eros sollicitudin ullamcorper.",
          initiallyExpanded: true,
        ),
      ],
    );
  }
}
