/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory, File;
import 'dart:math' show Random;
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:flutter_android/android_content.dart' show Context;
//import 'package:flutter_android/android_database.dart' show DatabaseUtils; // DEBUG

import 'api.dart' as API;
import 'model.dart';

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
      final File cacheFile = File("${cacheDir.path}/cache.db");
      final bool cacheCreated = !cacheFile.existsSync();
      final SQLiteDatabase db = await SQLiteDatabase.openOrCreateDatabase(cacheFile.path);
      if (cacheCreated) {
        await _clear(db); // load the database schema
      }
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

  void setName(final int playerID, final String name) {
    assert(playerID != null);
    _names[playerID] = name;
  }

  String getName(final int playerID) {
    return (playerID == null) ? "System" : _names[playerID];
  }

  Color getColor(final int playerID) {
    return (playerID == null) ? Colors.black : Colors.brown.shade800; // TODO
  }

  Future<int> getMaxEventID() async {
    final SQLiteCursor cursor = await _db.rawQuery("SELECT MAX(event_id) AS id FROM event LIMIT 1");
    try {
      return cursor.toList().first['id'];
    }
    finally {
      await cursor.close();
    }
  }

  Future<int> getMaxMessageID() async {
    final SQLiteCursor cursor = await _db.rawQuery("SELECT MAX(message_id) AS id FROM message LIMIT 1");
    try {
      return cursor.toList().first['id'];
    }
    finally {
      await cursor.close();
    }
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
    return await _db.replace(table: "user", values: <String, dynamic>{
      "player_id": playerID,
    });
  }

  Future<int> putEvent(final API.Event event) {
    assert(event != null);
    assert(event.id != null);

    return _db.replace(table: "event", values: <String, dynamic>{
      "event_id": event.id.toInt(),
      "event_timestamp": event.timestamp.toInt(),
      "event_predicate": event.predicate,
      "event_subject": event.hasSubjectId() ? event.subjectId.toInt() : null,
      "event_object": event.hasObjectId() ? event.objectId.toInt() : null,
    });
  }

  Future<int> putMessage(final API.Message message) {
    assert(message != null);
    assert(message.id != null);

    return _db.replace(table: "message", values: <String, dynamic>{
      "message_id": message.id.toInt(),
      "message_timestamp": message.timestamp.toInt(),
      "message_seen": 0, // always false initially
      "message_sender": message.hasSenderId() ? message.senderId.toInt() : null,
      "message_recipient": message.hasRecipientId() ? message.recipientId.toInt() : null,
      "message_language": message.hasLanguage() ? message.language : null,
      "message_text": message.text,
      "message_audio": null, // TODO
    });
  }

  Future<int> putPlayer(final API.Player player) {
    assert(player != null);
    assert(player.id != null);

    return _db.replace(table: "player", values: <String, dynamic>{
      "player_id": player.id.toInt(),
      "player_nick": player.nick,
      "player_rank": player.rank,
      "player_headset": 0, // TODO
      "player_heartrate": 40 + Random().nextInt(60), // TODO
      "player_distance": Random().nextInt(300), // TODO
      "player_position_x": null,
      "player_position_y": null,
      "player_position_z": null,
      "player_avatar": null, // TODO
    });
  }

  Future<int> putTarget(final API.Target target) {
    assert(target != null);
    assert(target.id != null);

    return _db.replace(table: "target", values: <String, dynamic>{
      "target_id": target.id.toInt(),
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
          position: null, // TODO
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
          position: null, // TODO
          avatar: row['player_avatar']
        );
      }).toList();
    }
    finally {
      await cursor.close();
    }
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
          language: row['message_language'],
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
