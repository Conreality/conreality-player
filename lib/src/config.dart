/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

////////////////////////////////////////////////////////////////////////////////

// TODO: make this a singleton instance, mirroring Cache.instance
class Config {
  static const DEFAULT_PORT = 50051;
  static const DEFAULT_URL = 'grpc://192.168.1.101:50051'; // 127.0.0.1:50051 on the emulator host

  Config({this.prefs});

  final SharedPreferences prefs;

  static Future<Config> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return Config(prefs: prefs);
  }

  Future<bool> clear() => prefs.clear();

  bool hasKey(final String key) => (prefs.get(key) != null);

  String getString(final String key) => prefs.getString(key);

  String getCurrentGameURL() => prefs.getString('game.url') ?? null;

  Future<Uri> setCurrentGameURL(final Uri gameURL) async {
    if (gameURL == null) {
      await Future.wait([
        prefs.remove('game.url'),
      ]);
    }
    else {
      await Future.wait([
        prefs.setString('game.url', gameURL.toString()),
      ]);
    }
    return gameURL;
  }
}
