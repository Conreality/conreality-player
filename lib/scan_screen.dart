/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'api.dart' as API;
import 'config.dart';
import 'connect_dialog.dart';
import 'game.dart';
import 'game_loader.dart';
import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

enum ScanMenuChoice { connect }

////////////////////////////////////////////////////////////////////////////////

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ScanState createState() => ScanState();
}

////////////////////////////////////////////////////////////////////////////////

class ScanState extends State<ScanScreen> {
  static const platform = MethodChannel('app.conreality.org/start');
  //final _items = List<String>.generate(5, (i) => "Item $i");

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _scan),
          PopupMenuButton<ScanMenuChoice>(
            onSelected: _onMenuAction,
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<ScanMenuChoice>>[
              PopupMenuItem<ScanMenuChoice>(
                value: ScanMenuChoice.connect,
                child: Text(Strings.connectToGame),
              ),
            ],
          ),
        ],
      ),
      drawer: ScanDrawer(),
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

  void _scan() {
    // TODO: scan QR code.
  }

  void _onMenuAction(final ScanMenuChoice choice) {
    switch (choice) {
      case ScanMenuChoice.connect:
        Config.load().then((final Config config) {
          showConnectDialog(context, config.getCurrentGameURL() ?? Config.DEFAULT_URL)
            .then((final Uri gameURL) {
              if (gameURL == null) throw ConnectCanceled();
              return config.setCurrentGame(Game(url: gameURL, title: Strings.connecting));
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

class ScanDrawer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[
      Divider(),

      ListTile(
        leading: Icon(Icons.chat),
        title: Text(Strings.chat),
        onTap: () {
          Navigator.of(context).pushNamed('/chat');
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text(Strings.compass),
        onTap: () {
          Navigator.of(context).pushNamed('/compass');
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text(Strings.map),
        onTap: () {
          Navigator.of(context).pushNamed('/map');
        },
      ),

      Divider(),

      ListTile(
        leading: Icon(Icons.report),
        title: Text(Strings.sendFeedback),
        onTap: () {
          launch(Strings.feedbackURL);
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
