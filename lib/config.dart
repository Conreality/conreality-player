/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'game.dart';

////////////////////////////////////////////////////////////////////////////////

class Config {
  Config({this.prefs});

  final SharedPreferences prefs;

  static Future<Config> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Config(prefs: prefs);
  }

  bool hasKey(final String key) => (prefs.get(key) != null);

  String getString(final String key) => prefs.getString(key);

  String getCurrentGameURL() => prefs.getString("game.url") ?? null;

  Future<bool> clear() => prefs.clear();

  Future<Game> setCurrentGame(final Game game) async {
    await Future.wait([
      prefs.setString('game.url', game.url.toString()),
      prefs.setString('game.uuid', game.uuid),
      prefs.setString('game.title', game.title),
    ]);
    return game;
  }
}
