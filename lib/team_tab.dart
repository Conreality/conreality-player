/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class TeamTab extends StatefulWidget {
  TeamTab({Key key, this.client}) : super(key: key);

  final API.Client client;

  @override
  State<TeamTab> createState() => TeamState();
}

////////////////////////////////////////////////////////////////////////////////

class TeamState extends State<TeamTab> {
  Future<API.PlayerList> _response;

  @override
  void initState() {
    super.initState();
    _response = Future.sync(() => widget.client.listPlayers(API.UnitID()..value = Int64(0)))
      .whenComplete(widget.client.disconnect);;
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<API.PlayerList>(
      future: _response,
      builder: (final BuildContext context, final AsyncSnapshot<API.PlayerList> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.grey,
                size: 300.0,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text(snapshot.error.toString()); // GrpcError
            return TeamList(snapshot.data.values);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TeamList extends StatelessWidget {
  final List<API.Player> players;

  TeamList(this.players);

  @override
  Widget build(final BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemCount: players.length,
      itemBuilder: (final BuildContext context, final int index) {
        final API.Player player = players[index];
        return ListTile(
          leading: CircleAvatar(child: Text(player.nick.substring(0, 1))),
          title: Text(player.nick),
          subtitle: Text(player.rank ?? "No rank"),
          trailing: Icon(Icons.info, color: Theme.of(context).disabledColor),
        );
      },
      separatorBuilder: (final BuildContext context, final int index) {
        return Divider();
      },
    );
  }
}
