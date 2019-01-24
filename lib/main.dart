/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chat_screen.dart';
import 'compass_screen.dart';
import 'discover_screen.dart';
import 'game_loader.dart';
import 'load.dart' show loadApp;
import 'map_screen.dart';

import 'src/game.dart' show Game;
import 'src/strings.dart' show Strings, StringsDelegate;
import 'src/generated/strings.dart' show GeneratedStrings;

////////////////////////////////////////////////////////////////////////////////

void main() => runApp(App());

////////////////////////////////////////////////////////////////////////////////

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

////////////////////////////////////////////////////////////////////////////////

class _AppState extends State<App> {
  Future<Game> _game;

  @override
  initState() {
    super.initState();
    _game = Future.sync(() => loadApp());
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (final BuildContext context) => Strings.of(context).appTitle,
      localizationsDelegates: [
        StringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: GeneratedStrings.supportedLocales,
      color: Colors.grey,
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder<Game>(
        future: _game,
        builder: (final BuildContext context, final AsyncSnapshot<Game> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return AppLoading(); // TODO: replace with splash screen
            case ConnectionState.done:
              final Game game = snapshot.data;
              if (snapshot.hasError || game == null) {
                return DiscoverScreen(title: Strings.of(context).appTitle);
              }
              return GameLoader(game: game);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
      routes: {
        '/chat': (context) => ChatScreen(title: Strings.of(context).chat),
        '/compass': (context) => CompassScreen(title: Strings.of(context).compass),
        '/map': (context) => MapScreen(title: Strings.of(context).map),
        '/discover': (context) => DiscoverScreen(title: Strings.of(context).appTitle),
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class AppLoading extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return SpinKitPulse(
      color: Colors.grey,
      size: 300.0,
    );
  }
}
