/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'config.dart';

////////////////////////////////////////////////////////////////////////////////

void exitGame(final BuildContext context) async {
  Config.load()
    .then((final Config config) => config.setCurrentGame(null))
    .then((_) => Navigator.of(context).pushReplacementNamed('/scan'));
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

enum GameMenuChoice { exit }
