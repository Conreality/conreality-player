/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'chat_tab.dart' show ChatState;
import 'game_screen.dart' show GameScreenState;
import 'map_tab.dart' show MapState;
import 'mission_tab.dart' show MissionState;
import 'player_tab.dart' show PlayerState;
import 'team_tab.dart' show TeamState;

final refreshGameScreenKey = GlobalKey<GameScreenState>(debugLabel: "Game screen");

final refreshMeTabKey   = GlobalKey<PlayerState>(debugLabel: "Me tab");
final refreshTeamTabKey = GlobalKey<TeamState>(debugLabel: "Team tab");
final refreshGameTabKey = GlobalKey<MissionState>(debugLabel: "Game tab");
final refreshChatTabKey = GlobalKey<ChatState>(debugLabel: "Chat tab");
final refreshMapTabKey  = GlobalKey<MapState>(debugLabel: "Map tab");
