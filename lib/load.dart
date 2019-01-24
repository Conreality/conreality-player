/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:grpc/grpc.dart' as gRPC;

import 'keys.dart';

import 'src/api.dart' as API;
import 'src/cache.dart' show Cache;
import 'src/client.dart' show Client;
import 'src/config.dart' show Config;
import 'src/connection.dart' show Connection;
import 'src/game.dart' show Game;
import 'src/speech.dart' show say;

////////////////////////////////////////////////////////////////////////////////

Future<Game> loadApp() async {
  final Config config = await Config.load();
  //await config.clear(); // DEBUG

  final bool hasGame = config.hasKey('game.url');

  return !hasGame ? null : Game(
    url:   Uri.tryParse(config.getString('game.url')),
    uuid:  config.getString('game.uuid'),
    title: config.getString('game.title'),
  );
}

////////////////////////////////////////////////////////////////////////////////

Future<API.GameInformation> loadGame() async {
  final Cache cache = await Cache.instance;
  //await cache.clear(); // DEBUG

  final Connection conn = await Connection.instance;
  final Client client = Client(conn);
  await client.ping();

  final API.GameInformation info = await client.rpc.getGameInfo(API.Nothing());

  // Players:
  final gRPC.ResponseStream<API.Player> players = client.rpc.listPlayers(API.UnitID()..id = Int64(0));
  players.forEach((final API.Player player) {
    print("-> player: ${player.writeToJson()}"); // DEBUG
    cache.putPlayer(player);

    if (true) { // TODO: check if loading already finished
      //refreshMeKey.currentState?.reload(); // TODO: only if own nick/rank/avatar changed
      refreshTeamKey.currentState?.reload();
      refreshChatKey.currentState?.reload(); // TODO: only in case of nick/avatar changes
      //refreshMapKey.currentState?.reload(); // TODO: only in case of nick/avatar changes
    }
  });

  // Units:
  final gRPC.ResponseStream<API.Unit> units = client.rpc.listUnits(API.UnitID()..id = Int64(0));
  units.forEach((final API.Unit unit) {
    print("-> unit: ${unit.writeToJson()}"); // DEBUG
    //cache.putUnit(unit);

    if (true) { // TODO: check if loading already finished
      //refreshMeKey.currentState?.reload(); // TODO: only if own unit changed
      refreshTeamKey.currentState?.reload();
      //refreshMapKey.currentState?.reload(); // TODO
    }
  });

  // Targets:
  final gRPC.ResponseStream<API.Target> targets = client.rpc.listTargets(API.UnitID()..id = Int64(0));
  targets.forEach((final API.Target target) {
    print("-> target: ${target.writeToJson()}"); // DEBUG
    cache.putTarget(target);

    if (true) { // TODO: check if loading already finished
      //refreshMapKey.currentState?.reload(); // TODO
    }
  });

  // Messages:
  final int seenMessageID = await cache.getMaxMessageID() ?? 0;
  final gRPC.ResponseStream<API.Message> messages = client.rpc.receiveMessages(API.MessageID()..id = Int64(seenMessageID));
  messages.forEach((final API.Message message) {
    print("-> message: ${message.writeToJson()}"); // DEBUG
    cache.putMessage(message);

    if (true) { // TODO: check if loading already finished
      refreshChatKey.currentState?.reload();
      // TODO: optional text-to-speech
    }
  });

  // Events:
  final int seenEventID = await cache.getMaxEventID() ?? 0;
  final gRPC.ResponseStream<API.Event> events = client.rpc.receiveEvents(API.EventID()..id = Int64(seenEventID));
  events.forEach((final API.Event event) {
    print("-> event: ${event.writeToJson()}"); // DEBUG
    cache.putEvent(event);

    if (true) { // TODO: check if loading already finished
      //refreshGameKey.currentState?.reload(); // TODO: only if game state changed
      final String announcement = composeEventAnnouncement(event);
      if (announcement != null) {
        say(announcement);
      }
    }
  });

  await cache.setPlayerID(2); // FIXME

  return info;
}

////////////////////////////////////////////////////////////////////////////////

String composeEventAnnouncement(final API.Event event) {
  switch (event.predicate) {
    case "started": return "Game started";
    case "paused":  return "Game paused";
    case "resumed": return "Game resumed";
    case "stopped": return "Game stopped";
    case "joined":  return "A new player joined";
    case "exited":  return "A player exited";
    default:        return null; // unknown predicate
  }
}
