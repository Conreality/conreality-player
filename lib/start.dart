/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'api.dart' as API;
import 'chat.dart';
import 'config.dart';
import 'compass.dart';
import 'connect.dart';
import 'game.dart';
import 'map.dart';
import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

enum StartChoice { connect }

////////////////////////////////////////////////////////////////////////////////

class StartScreen extends StatefulWidget {
  StartScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  StartState createState() => StartState();
}

////////////////////////////////////////////////////////////////////////////////

class StartState extends State<StartScreen> {
  static const platform = MethodChannel('app.conreality.org/start');
  //final _items = List<String>.generate(5, (i) => "Item $i");

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<StartChoice>(
            onSelected: _onMenuAction,
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<StartChoice>>[
              PopupMenuItem<StartChoice>(
                value: StartChoice.connect,
                child: Text(Strings.connectToGame),
              ),
            ],
          ),
        ],
      ),
      drawer: StartDrawer(),
      body: SpinKitRipple(
        color: Colors.grey,
        size: 300.0,
      ),
/*
      body: FutureBuilder<API.HelloResponse>(
        future: _discover(),
        builder: (final BuildContext context, final AsyncSnapshot<API.HelloResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: SpinKitRipple(
                  color: Colors.grey,
                  size: 300.0,
                )
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              //final HelloResponse response = snapshot.data; // TODO: response.list
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${_items[index]}"),
                  );
                },
              );
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
*/
    );
  }

  void _onMenuAction(final StartChoice choice) {
    switch (choice) {
      case StartChoice.connect:
        Config.load().then((final Config config) {
          showConnectDialog(context, config.getCurrentGameURL())
            .then((final Uri gameURL) {
              if (gameURL == null) throw ConnectCanceled();
              return config.setCurrentGame(Game(url: gameURL, title: Strings.connecting));
            })
            .then((final Game game) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return GameScreen(game: game);
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

class StartDrawer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[
      Divider(),

      ListTile(
        leading: Icon(Icons.chat),
        title: Text("Chat"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return ChatScreen(title: "Demo Chat"); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text("Compass"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return CompassScreen(title: "Demo Compass"); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.gamepad),
        title: Text("Game"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return GameScreen(game: Game(title: "Demo Game")); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text("Map"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return MapScreen(title: "Demo Map"); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.report),
        title: Text(Strings.sendFeedback),
        onTap: () {
          launch('https://github.com/conreality/conreality-player/issues/new');
        },
      ),

      AboutListTile(
        icon: FlutterLogo(), // TODO
        applicationVersion: Strings.appVersion,
        applicationIcon: FlutterLogo(), // TODO
        applicationLegalese: Strings.legalese,
        aboutBoxChildren: <Widget>[],
      ),
    ];
    return Drawer(child: ListView(primary: false, children: allDrawerItems));
  }
}
