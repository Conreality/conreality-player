/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory, File;
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:flutter_android/android_content.dart' show Context;
//import 'package:flutter_android/android_database.dart' show DatabaseUtils; // DEBUG
import 'package:latlong/latlong.dart' show LatLng;

import 'api.dart' as API;
import 'model.dart';

////////////////////////////////////////////////////////////////////////////////

class Cache {
  final SQLiteDatabase _db;
  final Map<int, String> _names = {};

  Cache._(this._db);

  static Future<Cache> of(final Uri gameURL) async {
    final Directory cacheDir = await Context.cacheDir;
    await cacheDir.create(recursive: true);
    final File cacheFile = File("${cacheDir.path}/cachev1.db");
    final bool cacheCreated = !cacheFile.existsSync();
    final SQLiteDatabase db = await SQLiteDatabase.openOrCreateDatabase(cacheFile.path);
    if (cacheCreated) {
      await _clear(db); // load the database schema
    }
    return Cache._(db);
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

  @deprecated
  Future<void> setPlayerID(final int playerID) async {
    await _db.execSQL("DELETE FROM user");
    return await _db.replace(table: "user", values: <String, dynamic>{
      "player_id": playerID,
    });
  }

  Future<int> putEvent(final API.Event event) {
    assert(event != null);
    assert(event.id != null);

    return _db.replace(
      table: "event",
      values: <String, dynamic>{
        "event_id": event.id.toInt(),
        "event_timestamp": event.timestamp.toInt(),
        "event_predicate": event.predicate,
        "event_subject": event.hasSubjectId() ? event.subjectId.toInt() : null,
        "event_object": event.hasObjectId() ? event.objectId.toInt() : null,
      },
    );
  }

  Future<int> putMessage(final API.Message message) {
    assert(message != null);
    assert(message.id != null);

    return _db.replace(
      table: "message",
      values: <String, dynamic>{
        "message_id": message.id.toInt(),
        "message_timestamp": message.timestamp.toInt(),
        "message_seen": 0, // always false initially
        "message_sender": message.hasSenderId() ? message.senderId.toInt() : null,
        "message_recipient": message.hasRecipientId() ? message.recipientId.toInt() : null,
        "message_language": message.hasLanguage() ? message.language : null,
        "message_text": message.text,
        "message_audio": null, // TODO
      },
    );
  }

  Future<int> putPlayer(final API.Player player) {
    assert(player != null);
    assert(player.id != null);
    assert(player.nick != null);

    return _db.replace(
      table: "player",
      values: <String, dynamic>{
        "player_id": player.id.toInt(),
        "player_nick": player.nick,
        "player_language": player.hasLanguage() ? player.language : null,
        "player_rank": player.hasRank() ? player.rank : null,
        "player_bio": player.hasBio() ? player.bio : null,
        "player_avatar": player.hasAvatar() ? player.avatar : null,
        "player_timestamp": null,
        "player_state": null,
        "player_headset": false,
        "player_heartrate": null,
        "player_latitude": null,
        "player_longitude": null,
        "player_altitude": null,
        "player_distance": null,
      },
    );
  }

  Future<int> putPlayerStatus(final API.PlayerStatus status) {
    assert(status != null);
    assert(status.playerId != null);

    return _db.update(
      table: "player",
      values: <String, dynamic>{
        "player_timestamp": DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
        "player_state": status.hasState() ? status.state : null,
        "player_headset": status.hasHeadset() ? status.headset : false,
        "player_heartrate": status.hasHeartrate() ? status.heartrate : null,
        "player_latitude": status.hasLocation() ? status.location.latitude : null,
        "player_longitude": status.hasLocation() ? status.location.longitude : null,
        "player_altitude": status.hasLocation() ? status.location.altitude : null,
        "player_distance": null, // TODO: calculate this
      },
      where: "player_id = ?",
      whereArgs: <String>[status.playerId.toString()],
    );
  }

  Future<int> putTarget(final API.Target target) {
    assert(target != null);
    assert(target.id != null);

    return _db.replace(table: "target", values: <String, dynamic>{
      "target_id": target.id.toInt(),
    });
  }

  Future<Player> getPlayer(final int playerID) async {
    assert(playerID != null);

    final SQLiteCursor cursor = await _db.rawQuery("SELECT * FROM player WHERE player_id = ? LIMIT 1", [playerID.toString()]);
    try {
      final result = cursor.toList();
      return result.isEmpty ? null : result.map((Map<String, dynamic> row) {
        return Player(
          id: row['player_id'],
          nick: row['player_nick'],
          language: row['player_language'],
          rank: row['player_rank'],
          bio: row['player_bio'],
          avatar: row['player_avatar'],
          timestamp: row['player_timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(row['player_timestamp'] * 1000) : null,
          state: row['player_state'] != null ? Player.parseState(row['player_state']) : null,
          headset: row['player_headset'] == 1,
          heartrate: row['player_heartrate'],
          location: row['player_latitude'] != null ? LatLng(row['player_latitude'], row['player_longitude']) : null,
          distance: row['player_distance'],
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
          language: row['player_language'],
          rank: row['player_rank'],
          bio: row['player_bio'],
          avatar: row['player_avatar'],
          timestamp: row['player_timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(row['player_timestamp'] * 1000) : null,
          state: row['player_state'] != null ? Player.parseState(row['player_state']) : null,
          headset: row['player_headset'] == 1,
          heartrate: row['player_heartrate'],
          location: row['player_latitude'] != null ? LatLng(row['player_latitude'], row['player_longitude']) : null,
          distance: row['player_distance'],
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
