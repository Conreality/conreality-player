/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'connect_dialog.dart';
import 'discover_drawer.dart';
import 'discover_tab.dart';
import 'game_loader.dart';

import 'src/config.dart' show Config;
import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

enum DiscoverMenuChoice { connect }

////////////////////////////////////////////////////////////////////////////////

class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({Key key, this.title}) : super(key: key);

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
            PopupMenuButton<DiscoverMenuChoice>(
              onSelected: (final DiscoverMenuChoice choice) => _onMenuAction(choice, context),
              itemBuilder: (final BuildContext context) => <PopupMenuEntry<DiscoverMenuChoice>>[
                PopupMenuItem<DiscoverMenuChoice>(
                  value: DiscoverMenuChoice.connect,
                  child: Text(Strings.of(context).connectToGame),
                ),
              ],
            ),
          ],
          bottom: TabBar(tabs: _tabs),
        ),
        drawer: DiscoverDrawer(),
        body: TabBarView(
          children: <Widget>[
            Center(child: DiscoverTab()),
            Center(child: Text("")), // TODO
          ],
        ),
      ),
    );
  }

  void _scan() {
    // TODO: scan QR code.
  }

  void _onMenuAction(final DiscoverMenuChoice choice, final BuildContext context) {
    switch (choice) {
      case DiscoverMenuChoice.connect:
        Config.load().then((final Config config) {
          showConnectDialog(context, config.getCurrentGameURL() ?? Config.DEFAULT_URL)
            .then((final Uri gameURL) {
              if (gameURL == null) throw ConnectCanceled();
              return config.setCurrentGameURL(gameURL);
            })
            .then((final Uri gameURL) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return GameLoader(gameURL: gameURL);
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
