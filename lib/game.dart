/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'src/config.dart' show Config;

////////////////////////////////////////////////////////////////////////////////

void exitGame(final BuildContext context) async {
  Config.load()
    .then((final Config config) => config.setCurrentGame(null))
    .then((_) => Navigator.of(context).pushReplacementNamed('/discover'));
}

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

enum GameMenuChoice { share, exit }
