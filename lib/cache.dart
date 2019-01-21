/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:flutter_android/android_content.dart' show Context;
//import 'package:flutter_android/android_database.dart' show DatabaseUtils; // DEBUG

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

  static void _clear(final SQLiteDatabase db) async {
    await db.execSQL('PRAGMA foreign_keys=OFF');
    final String sqlSchema = await rootBundle.loadString('etc/schema.sql');
    for (var sql in sqlSchema.split(";\n")) {
      if (sql.isNotEmpty) {
        await db.execSQL(sql);
      }
    }
    await db.execSQL('PRAGMA foreign_keys=ON');
  }
}
