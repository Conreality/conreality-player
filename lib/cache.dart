/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show Directory;

import 'package:flutter_sqlcipher/sqlite.dart';
import 'package:flutter_android/android_content.dart' show Context;
//import 'package:flutter_android/android_database.dart' show DatabaseUtils; // DEBUG

////////////////////////////////////////////////////////////////////////////////

class Cache {
  Cache({this.db});

  final SQLiteDatabase db;

  static Future<Cache> load() async {
    final Directory cacheDir = await Context.cacheDir;
    await cacheDir.create(recursive: true);
    final String cachePath = "${cacheDir.path}/cache.db";
    final SQLiteDatabase db = await SQLiteDatabase.openOrCreateDatabase(cachePath);
    return Cache(db: db);
  }
}
