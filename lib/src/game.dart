/* This is free and unencumbered software released into the public domain. */

//import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'config.dart' show Config;

////////////////////////////////////////////////////////////////////////////////

void exitGame(final BuildContext context) async {
  Config.load()
    .then((final Config config) => config.setCurrentGameURL(null))
    .then((_) => Navigator.of(context).pushReplacementNamed('/discover'));
}

////////////////////////////////////////////////////////////////////////////////

void terminateApp(final BuildContext context) async {
  bg.BackgroundGeolocation.removeListeners();
  await bg.BackgroundGeolocation.stop();
  await SystemNavigator.pop();
  //exit(0); // not needed
}
