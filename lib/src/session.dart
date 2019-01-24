/* This is free and unencumbered software released into the public domain. */

import 'model.dart';

////////////////////////////////////////////////////////////////////////////////

class GameSession {
  final Uri url;
  final Game game;
  final int playerID;

  GameSession({this.url, this.game, this.playerID});
}
