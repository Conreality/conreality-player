/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'compass_screen.dart' show CompassScreen;
import 'discover_screen.dart' show DiscoverScreen;
import 'game_loader.dart' show GameLoader;
import 'load.dart' show loadApp;
import 'map_screen.dart' show MapScreen;

import 'src/strings.dart' show Strings, StringsDelegate;
import 'src/generated/strings.dart' show GeneratedStrings;

////////////////////////////////////////////////////////////////////////////////

void onHeadlessTask(final bg.HeadlessEvent event) async {
  print('BackgroundGeolocation.onHeadlessTask: $event'); // TODO
}

void main() {
  runApp(App());
  //bg.BackgroundGeolocation.registerHeadlessTask(onHeadlessTask); // FIXME
}

////////////////////////////////////////////////////////////////////////////////

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

////////////////////////////////////////////////////////////////////////////////

class _AppState extends State<App> {
  Future<Uri> _gameURL;

  @override
  initState() {
    super.initState();
    _gameURL = Future.sync(() => loadApp());
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
      home: FutureBuilder<Uri>(
        future: _gameURL,
        builder: (final BuildContext context, final AsyncSnapshot<Uri> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return AppLoading(); // TODO: replace with splash screen?
            case ConnectionState.done:
              final Uri gameURL = snapshot.data;
              if (snapshot.hasError || gameURL == null) {
                return DiscoverScreen(title: Strings.of(context).appTitle);
              }
              return GameLoader(gameURL: gameURL);
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
      routes: {
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
