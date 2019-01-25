/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:grpc/grpc.dart' as gRPC;
import 'package:latlong/latlong.dart' show LatLng;

import 'keys.dart';

import 'src/api.dart' as API;
import 'src/cache.dart' show Cache;
import 'src/client.dart' show Client;
import 'src/config.dart' show Config;
import 'src/connection.dart' show Connection;
import 'src/model.dart' show Game, GameState, Player;
import 'src/session.dart' show GameSession;
import 'src/speech.dart' show say;

////////////////////////////////////////////////////////////////////////////////

Future<Uri> loadApp() async {
  final Config config = await Config.load();
  //await config.clear(); // DEBUG

  if (!config.hasKey('game.url')) {
    return null; // not connected to a game
  }

  final Uri gameURL = Uri.tryParse(config.getString('game.url'));
  if (gameURL == null) {
    assert(false, "unreachable");
    return null; // unreachable
  }

  return gameURL;
}

////////////////////////////////////////////////////////////////////////////////

Future<GameSession> loadGame(final Uri gameURL) async {
  final Cache cache = await Cache.of(gameURL);
  //await cache.clear(); // DEBUG

  print("gameURL=${gameURL}"); // DEBUG
  final Connection conn = await Connection.to(gameURL); // (re)connect to game
  final Client client = Client(conn);
  await client.ping();

  // Game:
  final API.GameInformation info = await client.rpc.getGameInfo(API.Nothing());

  // Player nick:
  final String playerNick = gameURL.userInfo;
  print("playerNick=${playerNick}"); // DEBUG
  assert(playerNick != null && playerNick.isNotEmpty);

  // Player ID:
  int playerID = (await client.rpc.lookupEntityByName(API.TextString()..value = playerNick)).id?.toInt();
  if (playerID == null || playerID == 0) {
    playerID = (await client.rpc.addPlayer(API.Player()..nick = playerNick)).id?.toInt();
  }
  print("playerID=${playerID}"); // DEBUG
  assert(playerID != null && playerID > 0);
  await cache.setPlayerID(playerID);

  // Game session:
  final GameSession session = GameSession(
    url: gameURL,
    connection: conn,
    cache: cache,
    game: Game(
      state: Game.parseState(info.state),
      origin: LatLng(info.origin.latitude, info.origin.longitude),
      radius: info.radius,
      language: info.language,
      title: info.title,
      link: info.link,
      summary: info.summary,
      address: info.address,
      theater: info.theater,
      rules: info.rules,
      schedule: info.schedule,
    ),
    playerID: playerID,
  );

  // Players:
  final gRPC.ResponseStream<API.Player> players = client.rpc.listPlayers(API.UnitID()..id = Int64(0));
  players.forEach((final API.Player player) {
    print("-> player: ${player.writeToJson()}"); // DEBUG
    cache.putPlayer(player);
    cache.setName(player.id.toInt(), player.nick);

    if (true) { // TODO: check if loading already finished
      refreshMeTabKey.currentState?.reload(); // TODO: only if own nick/rank/avatar changed
      refreshTeamTabKey.currentState?.reload();
      refreshChatTabKey.currentState?.reload(); // TODO: only in case of nick/avatar changes
      refreshMapTabKey.currentState?.reload(); // TODO: only in case of nick/avatar changes
    }
  });

  // Player Statuses:
  final gRPC.ResponseStream<API.PlayerStatus> statuses = client.rpc.receivePlayerStatuses(API.UnitID()..id = Int64(0));
  statuses.forEach((final API.PlayerStatus status) {
    print("-> player-status: ${status.writeToJson()}"); // DEBUG
    cache.putPlayerStatus(status);

    if (true) { // TODO: check if loading already finished
      //refreshMeTabKey.currentState?.reload(); // DEBUG
      refreshTeamTabKey.currentState?.reload();
      //refreshMapTabKey.currentState?.reload();
    }
  });

  // Units:
  final gRPC.ResponseStream<API.Unit> units = client.rpc.listUnits(API.UnitID()..id = Int64(0));
  units.forEach((final API.Unit unit) {
    print("-> unit: ${unit.writeToJson()}"); // DEBUG
    //cache.putUnit(unit);

    if (true) { // TODO: check if loading already finished
      refreshMeTabKey.currentState?.reload(); // TODO: only if own unit changed
      refreshTeamTabKey.currentState?.reload();
      refreshMapTabKey.currentState?.reload();
    }
  });

  // Targets:
  final gRPC.ResponseStream<API.Target> targets = client.rpc.listTargets(API.UnitID()..id = Int64(0));
  targets.forEach((final API.Target target) {
    print("-> target: ${target.writeToJson()}"); // DEBUG
    cache.putTarget(target);

    if (true) { // TODO: check if loading already finished
      refreshMapTabKey.currentState?.reload();
    }
  });

  // Messages:
  final int seenMessageID = await cache.getMaxMessageID() ?? 0;
  final gRPC.ResponseStream<API.Message> messages = client.rpc.receiveMessages(API.MessageID()..id = Int64(seenMessageID));
  messages.forEach((final API.Message message) {
    print("-> message: ${message.writeToJson()}"); // DEBUG
    cache.putMessage(message);

    if (true) { // TODO: check if loading already finished
      refreshChatTabKey.currentState?.reload();
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
      final GameState newState = Game.parseState(event.predicate);
      if (newState != null && newState != session.game.state) {
        session.game.setState(newState);
        refreshGameScreenKey.currentState?.reload();
        refreshGameTabKey.currentState?.reload();
      }

      final String announcement = composeEventAnnouncement(event);
      if (announcement != null) {
        say(announcement);
      }
    }
  });

  return session;
}

////////////////////////////////////////////////////////////////////////////////

String composeEventAnnouncement(final API.Event event) {
  switch (event.predicate) {
    case "begun":   return "Game started";
    case "paused":  return "Game paused";
    case "resumed": return "Game resumed";
    case "ended":   return "Game stopped";
    case "joined":  return "A new player joined";
    case "exited":  return "A player exited";
    default:        return null; // unknown predicate
  }
}
