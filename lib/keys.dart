/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'chat_tab.dart' show ChatState;
import 'map_tab.dart' show MapState;
import 'mission_tab.dart' show MissionState;
import 'player_tab.dart' show PlayerState;
import 'team_tab.dart' show TeamState;

final refreshMeKey   = GlobalKey<PlayerState>(debugLabel: "Me");
final refreshTeamKey = GlobalKey<TeamState>(debugLabel: "Team");
final refreshGameKey = GlobalKey<MissionState>(debugLabel: "Game");
final refreshChatKey = GlobalKey<ChatState>(debugLabel: "Chat");
final refreshMapKey  = GlobalKey<MapState>(debugLabel: "Map");
