/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'chat_tab.dart' show ChatTabState;
import 'game_screen.dart' show GameScreenState;
import 'game_tab.dart' show GameTabState;
import 'map_tab.dart' show MapTabState;
import 'player_screen.dart' show PlayerScreenState;
import 'player_tab.dart' show PlayerTabState;
import 'team_tab.dart' show TeamTabState;

final refreshGameScreenKey   = GlobalKey<GameScreenState>(debugLabel: "Game screen");
final refreshPlayerScreenKey = GlobalKey<PlayerScreenState>(debugLabel: "Player screen");

final refreshMeTabKey   = GlobalKey<PlayerTabState>(debugLabel: "Me tab");
final refreshTeamTabKey = GlobalKey<TeamTabState>(debugLabel: "Team tab");
final refreshGameTabKey = GlobalKey<GameTabState>(debugLabel: "Game tab");
final refreshChatTabKey = GlobalKey<ChatTabState>(debugLabel: "Chat tab");
final refreshMapTabKey  = GlobalKey<MapTabState>(debugLabel: "Map tab");
