/* This is free and unencumbered software released into the public domain. */

import 'cache.dart' show Cache;
import 'connection.dart' show Connection;
import 'model.dart' show Game;

////////////////////////////////////////////////////////////////////////////////

class GameSession {
  final Uri url;
  final Connection connection;
  final Cache cache;
  final Game game;
  final int playerID;

  GameSession({this.url, this.connection, this.cache, this.game, this.playerID});
}
