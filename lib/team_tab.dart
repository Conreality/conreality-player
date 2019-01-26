/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';

import 'keys.dart' show refreshPlayerScreenKey;
import 'player_screen.dart';
import 'player_status.dart' show PlayerStatus;

import 'src/model.dart' show Player;
import 'src/session.dart' show GameSession;
import 'src/spinner.dart' show Spinner;

////////////////////////////////////////////////////////////////////////////////

class TeamTab extends StatefulWidget {
  final GameSession session;

  TeamTab({Key key, @required this.session})
    : assert(session != null),
      super(key: key);

  @override
  State<TeamTab> createState() => TeamTabState();
}

////////////////////////////////////////////////////////////////////////////////

class TeamTabState extends State<TeamTab> {
  List<Player> _players;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() async {
    final GameSession session = widget.session;
    final List<Player> players = await session.cache.listPlayers();
    setState(() {
      _players = players;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return (_players != null) ?
      TeamList(session: widget.session, players: _players) :
      Spinner();
  }
}

////////////////////////////////////////////////////////////////////////////////

class TeamList extends StatelessWidget {
  final GameSession session;
  final List<Player> players;

  TeamList({Key key, @required this.session, this.players})
    : assert(session != null),
      super(key: key);

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
          leading: CircleAvatar(
            child: Text(player.nick.substring(0, 1)),
            backgroundColor: session.cache.getColor(player.id),
          ),
          title: Row(
            children: <Widget>[
              Text(player.nick),
              Container(
                child: Text(player.rank != null && player.rank.isNotEmpty ? player.rank : "", style: style),
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          subtitle: PlayerStatus(session: session, player: player, isSelf: player.id == session.playerID),
          trailing: GestureDetector(
            child: Icon(Icons.info, color: Theme.of(context).disabledColor),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return PlayerScreen(key: refreshPlayerScreenKey, session: session, playerID: player.id);
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
