/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'api.dart' as API;
import 'config.dart';
//import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

class Game {
  Game({this.url, this.uuid, this.title});

  final Uri url;

  final String uuid;

  final String title;

  String host() => url.host;

  int port() => url.hasPort ? url.port : Config.DEFAULT_PORT;
}

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  GameState createState() => GameState();
}

////////////////////////////////////////////////////////////////////////////////

class GameState extends State<GameScreen> {
  static const platform = MethodChannel('app.conreality.org/game');

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? "?"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: _ignore),
        ],
      ),
      body: FutureBuilder<API.HelloResponse>(
        future: _connect(),
        builder: (final BuildContext context, final AsyncSnapshot<API.HelloResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: SpinKitRipple(
                  color: Colors.grey,
                  size: 300.0,
                )
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              final API.HelloResponse response = snapshot.data; // TODO: response.list
              return Text(response.name);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
    );
  }

  void _ignore() {}

  Future<API.HelloResponse> _connect() async {
    final game = widget.game;
    final creds = gRPC.ChannelCredentials.insecure();
    final channel = gRPC.ClientChannel(game.host(),
      port: game.port(),
      options: gRPC.ChannelOptions(credentials: creds),
    );
    final stub = API.MasterClient(channel);
    final name = "Flutter";
    try {
      return await stub.hello(API.HelloRequest()..name = name);
    }
    finally {
      channel.shutdown();
    }
  }
}
