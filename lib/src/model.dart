/* This is free and unencumbered software released into the public domain. */

import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Color;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:latlong/latlong.dart' show LatLng;

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

enum GameState {
  planned,
  begun,
  paused,
  resumed,
  ended,
}

enum GameAction {
  begin,
  pause,
  resume,
  end,
}

////////////////////////////////////////////////////////////////////////////////

class Game {
  GameState state;
  final LatLng origin;
  final double radius;
  final String title;
  final String mission;
  final String rules;

  Game({this.state, this.origin, this.radius, this.title, this.mission, this.rules});

  static GameState parseState(final String state) {
    switch (state) {
      case "planned": return GameState.planned;
      case "begun":   return GameState.begun;
      case "paused":  return GameState.paused;
      case "resumed": return GameState.resumed;
      case "ended":   return GameState.ended;
      default:        return null; // unknown state
    }
  }

  void setState(final GameState newState) {
    state = newState;
  }
}

////////////////////////////////////////////////////////////////////////////////

/// An ingame position, in meters from the game origin.
class Position {
  final double x;
  final double y;
  final double z;

  Position({this.x, this.y, this.z});
}

////////////////////////////////////////////////////////////////////////////////

/// The entity type.
enum EntityType {
  player,
  target,
  unit,
}

////////////////////////////////////////////////////////////////////////////////

/// An abstract entity.
abstract class Entity {
  final int id;

  Entity({this.id});

  EntityType get type;
  String get name;
}

////////////////////////////////////////////////////////////////////////////////

/// A corporeal entity, aka object.
abstract class Object extends Entity {
  final double orientation;
  final double mass;
  final double radius;
  final Color color;

  Object({final int id, this.orientation, this.mass, this.radius, this.color}) : super(id: id);
}

////////////////////////////////////////////////////////////////////////////////

/// A player.
class Player extends Object {
  final String nick;
  final String rank;
  final bool headset;
  final int heartrate;
  final double distance;
  final Position position;
  final Uint8List avatar;

  bool get hasRank => rank != null && rank.isNotEmpty;
  bool get hasHeadset => headset == true;
  bool get hasHeartrate => heartrate != null;
  bool get hasDistance => distance != null;
  bool get hasPosition => position != null;
  bool get hasAvatar => avatar != null;

  Player({
    final int id,
    final double orientation,
    final double mass,
    final double radius,
    final Color color,
    this.nick,
    this.rank,
    this.headset,
    this.heartrate,
    this.distance,
    this.position,
    this.avatar,
  }) : super(id: id, orientation: orientation, mass: mass, radius: radius, color: color);

  @override
  EntityType get type => EntityType.player;

  @override
  String get name => nick;

  double distanceTo(final Player other) {
    return null; // unknown
  }
}

////////////////////////////////////////////////////////////////////////////////

/// A designated target.
class Target extends Object {
  Target({final int id}) : super(id: id);

  @override
  EntityType get type => EntityType.target;

  @override
  String get name => null; // TODO
}

////////////////////////////////////////////////////////////////////////////////

/// A game event.
class Event {
  // TODO
}

////////////////////////////////////////////////////////////////////////////////

/// A message.
class Message {
  final int id;
  final DateTime timestamp;
  final bool seen;
  final int sender;
  final int recipient;
  final String language;
  final String text;
  final Uint8List audio;

  Message({this.id, this.timestamp, this.seen, this.sender, this.recipient, this.language, this.text, this.audio});

  bool get hasSender => sender != null;
  bool get hasRecipient => recipient != null;
  bool get isSystem => sender == null;
  bool get isPrivate => recipient != null;
  bool get isLanguageKnown => language != null;
  bool get hasText => text != null;
  bool get hasAudio => audio != null;

  API.Message toRPC() {
    return API.Message()
      ..senderId = Int64(sender ?? 0)
      ..recipientId = Int64(recipient ?? 0)
      ..language = language
      ..text = text;
  }
}
