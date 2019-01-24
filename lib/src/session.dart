/* This is free and unencumbered software released into the public domain. */

import 'model.dart';

////////////////////////////////////////////////////////////////////////////////

class GameSession {
  final Uri url;
  final Game game;
  final Player player;

  GameSession({this.url, this.game, this.player});
}
