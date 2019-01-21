/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:flutter_android/android_content.dart' show Context;
//import 'package:flutter_android/android_database.dart' show DatabaseUtils; // DEBUG

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class Cache {
  final SQLiteDatabase _db;

  Cache._(this._db);

  static Cache _instance;

  static Future<Cache> get instance async {
    if (_instance == null) {
      final Directory cacheDir = await Context.cacheDir;
      await cacheDir.create(recursive: true);
      final String cachePath = "${cacheDir.path}/cache.db";
      final SQLiteDatabase db = await SQLiteDatabase.openOrCreateDatabase(cachePath);
      _clear(db);
      _instance = Cache._(db);
    }
    return _instance;
  }

  static Future<void> _clear(final SQLiteDatabase db) async {
    await db.execSQL('PRAGMA foreign_keys=OFF');
    final String sqlSchema = await rootBundle.loadString('etc/schema.sql');
    for (var sql in sqlSchema.split(";\n")) {
      if (sql.isNotEmpty) {
        await db.execSQL(sql);
      }
    }
    await db.execSQL('PRAGMA foreign_keys=ON');
  }

  SQLiteDatabase get db => _db;

  Future<void> clear() => _clear(_db);

  Future<int> addPlayer(final API.Player player) {
    return _db.insert(table: "team", values: <String, dynamic>{
      "player_id": player.id.toInt(),
      "player_nick": player.nick,
      "player_rank": player.rank,
      "player_headset": 1, // TODO
      "player_heartrate": 40 + Random().nextInt(60), // TODO
      "player_distance": Random().nextInt(300), // TODO
      "player_avatar": null, // TODO
    });
  }

  Future<List<Player>> listPlayers() async {
    final SQLiteCursor cursor = await _db.rawQuery("SELECT * FROM team ORDER BY player_nick ASC");
    try {
      return cursor.toList().map((Map<String, dynamic> row) {
        return Player(
          id: row['player_id'],
          nick: row['player_nick'],
          rank: row['player_rank'],
          headset: row['player_headset'] == 1,
          heartrate: row['player_heartrate'],
          distance: row['player_distance'],
          avatar: row['player_avatar']
        );
      }).toList();
    }
    finally {
      await cursor.close();
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class Player {
  final int id;
  final String nick;
  final String rank;
  final bool headset;
  final int heartrate;
  final double distance;
  final Uint8List avatar;

  Player({this.id, this.nick, this.rank, this.headset, this.heartrate, this.distance, this.avatar});
}
