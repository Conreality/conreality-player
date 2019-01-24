/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'config.dart' show Config;

////////////////////////////////////////////////////////////////////////////////

void exitGame(final BuildContext context) async {
  Config.load()
    .then((final Config config) => config.setCurrentGameURL(null))
    .then((_) => Navigator.of(context).pushReplacementNamed('/discover'));
}
