/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';

import 'player_screen.dart';
import 'player_status.dart' show PlayerStatus;

import 'src/cache.dart' show Cache;
import 'src/model.dart' show Player;
import 'src/spinner.dart' show Spinner;

////////////////////////////////////////////////////////////////////////////////

class TeamTab extends StatefulWidget {
  TeamTab({Key key}) : super(key: key);

  @override
  State<TeamTab> createState() => TeamState();
}

////////////////////////////////////////////////////////////////////////////////

class TeamState extends State<TeamTab> {
  Future<List<Player>> _data;
  Cache _cache;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    setState(() {
      _data = Future.sync(() => _load());
    });
  }

  Future<List<Player>> _load() async {
    if (_cache == null) {
      _cache = await Cache.instance;
    }
    return _cache.listPlayers();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: _data,
      builder: (final BuildContext context, final AsyncSnapshot<List<Player>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Spinner();
          case ConnectionState.done:
            if (snapshot.hasError) return Text(snapshot.error.toString()); // GrpcError
            return TeamList(snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TeamList extends StatelessWidget {
  final List<Player> players;

  TeamList(this.players);

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color, fontSize: 12.0);
    return ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemCount: players.length,
      itemBuilder: (final BuildContext context, final int index) {
        final player = players[index];
        return ListTile(
          leading: CircleAvatar(child: Text(player.nick.substring(0, 1))),
          title: Row(
            children: <Widget>[
              Text(player.nick),
              Container(
                child: Text(player.rank != null && player.rank.isNotEmpty ? player.rank : "No rank", style: style),
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          subtitle: PlayerStatus(player: player),
          trailing: GestureDetector(
            child: Icon(Icons.info, color: Theme.of(context).disabledColor),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return PlayerScreen(player: player);
                  }
                )
              );
            }
          ),
        );
      },
      separatorBuilder: (final BuildContext context, final int index) {
        return Divider();
      },
    );
  }
}
