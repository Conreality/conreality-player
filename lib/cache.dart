/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

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
    return _db.insert(table: "player", values: <String, dynamic>{
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
    final SQLiteCursor cursor = await _db.rawQuery("SELECT * FROM player ORDER BY player_nick ASC");
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

  Future<int> sendMessage(final API.Message message) {
    return _db.insert(table: "message", values: <String, dynamic>{
      "message_id": null, // TODO
      "message_timestamp": 0, // TODO
      "message_seen": 0,
      "message_sender": null, // TODO
      "message_recipient": null, // TODO
      "message_text": message.text,
      "message_audio": null, // TODO
    });
  }

  Future<List<Message>> fetchMessages() async {
    final SQLiteCursor cursor = await _db.rawQuery("SELECT * FROM message ORDER BY message_id DESC");
    try {
      return cursor.toList().map((Map<String, dynamic> row) {
        return Message(
          id: row['message_id'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(row['message_timestamp']),
          seen: row['message_seen'] == 1,
          sender: row['message_sender'],
          recipient: row['message_recipient'],
          text: row['message_text'],
          audio: row['message_audio'],
        );
      }).toList();
    }
    finally {
      await cursor.close();
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

//class Game {} // TODO

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

////////////////////////////////////////////////////////////////////////////////

class Message {
  final int id;
  final DateTime timestamp;
  final bool seen;
  final Player sender;
  final Player recipient;
  final String text;
  final Uint8List audio;

  Message({this.id, this.timestamp, this.seen, this.sender, this.recipient, this.text, this.audio});
}

////////////////////////////////////////////////////////////////////////////////

class Target {
  final int id;

  Target({this.id});
}
