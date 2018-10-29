/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'config.dart';
import 'connect_dialog.dart';
import 'game.dart';
import 'game_loader.dart';
import 'scan_drawer.dart';
import 'scan_tab.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

enum ScanMenuChoice { connect }

////////////////////////////////////////////////////////////////////////////////

class ScanScreen extends StatelessWidget {
  ScanScreen({Key key, this.title}) : super(key: key);

  final String title;

  final List<Tab> _tabs = <Tab>[
    Tab(child: LocalTabLabel()),
    Tab(child: SavedTabLabel()),
  ];

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.camera_alt), onPressed: _scan),
            PopupMenuButton<ScanMenuChoice>(
              onSelected: (final ScanMenuChoice choice) => _onMenuAction(choice, context),
              itemBuilder: (final BuildContext context) => <PopupMenuEntry<ScanMenuChoice>>[
                PopupMenuItem<ScanMenuChoice>(
                  value: ScanMenuChoice.connect,
                  child: Text(Strings.of(context).connectToGame),
                ),
              ],
            ),
          ],
          bottom: TabBar(tabs: _tabs),
        ),
        drawer: ScanDrawer(),
        body: TabBarView(
          children: <Widget>[
            Center(child: ScanTab()),
            Center(child: Text("TODO")), // TODO
          ],
        ),
      ),
    );
  }

  void _scan() {
    // TODO: scan QR code.
  }

  void _onMenuAction(final ScanMenuChoice choice, final BuildContext context) {
    switch (choice) {
      case ScanMenuChoice.connect:
        Config.load().then((final Config config) {
          showConnectDialog(context, config.getCurrentGameURL() ?? Config.DEFAULT_URL)
            .then((final Uri gameURL) {
              if (gameURL == null) throw ConnectCanceled();
              return config.setCurrentGame(Game(url: gameURL));
            })
            .then((final Game game) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return GameLoader(game: game);
                  }
                )
              );
            })
            .catchError((e) {
              // the connect dialog was cancelled
            }, test: (e) => e is ConnectCanceled);
        });
        break;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class LocalTabLabel extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Text(Strings.of(context).local.toUpperCase(),
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SavedTabLabel extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Text(Strings.of(context).saved.toUpperCase(),
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}
