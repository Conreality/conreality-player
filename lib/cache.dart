/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;
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
  static Map<int, String> _names = {};

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

  String getName(final int playerID) {
    return (playerID == null) ? "System" : _names[playerID];
  }

  Color getColor(final int playerID) {
    return (playerID == null) ? Colors.black : Colors.brown.shade800;
  }

  Future<int> getPlayerID() async {
    final SQLiteCursor cursor = await _db.rawQuery("SELECT player_id FROM user LIMIT 1");
    try {
      return cursor.toList().first['player_id'];
    }
    finally {
      await cursor.close();
    }
  }

  Future<void> setPlayerID(final int playerID) async {
    await _db.execSQL("DELETE FROM user");
    return await _db.insert(table: "user", values: <String, dynamic>{
      "player_id": playerID,
    });
  }

  Future<int> addPlayer(final API.Player player) {
    _names[player.id.toInt()] = player.nick;
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

  Future<Player> getPlayer([final int playerID]) async {
    final arg = (playerID ?? await getPlayerID()).toString();
    final SQLiteCursor cursor = await _db.rawQuery("SELECT * FROM player WHERE player_id = ? LIMIT 1", [arg]);
    try {
      final result = cursor.toList();
      return result.isEmpty ? null : result.map((Map<String, dynamic> row) {
        return Player(
          id: row['player_id'],
          nick: row['player_nick'],
          rank: row['player_rank'],
          headset: row['player_headset'] == 1,
          heartrate: row['player_heartrate'],
          distance: row['player_distance'],
          avatar: row['player_avatar']
        );
      }).first;
    }
    finally {
      await cursor.close();
    }
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
          timestamp: DateTime.fromMillisecondsSinceEpoch(row['message_timestamp'] * 1000),
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

  bool get hasRank => rank != null && rank.isNotEmpty;
  bool get hasHeadset => headset == true;
  bool get hasHeartrate => heartrate != null;
  bool get hasDistance => distance != null;
  bool get hasAvatar => avatar != null;

  Player({this.id, this.nick, this.rank, this.headset, this.heartrate, this.distance, this.avatar});
}

////////////////////////////////////////////////////////////////////////////////

class Message {
  final int id;
  final DateTime timestamp;
  final bool seen;
  final int sender;
  final int recipient;
  final String text;
  final Uint8List audio;

  Message({this.id, this.timestamp, this.seen, this.sender, this.recipient, this.text, this.audio});

  bool get isSystem => sender == null;
  bool get isPrivate => recipient != null;
  bool get hasText => text != null;
  bool get hasAudio => audio != null;
}

////////////////////////////////////////////////////////////////////////////////

class Target {
  final int id;

  Target({this.id});
}
