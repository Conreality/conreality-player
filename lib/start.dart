/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'package:grpc/grpc.dart' as gRPC;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat.dart';
import 'compass.dart';
import 'game.dart';
import 'map.dart';

import 'generated/conreality.pb.dart';
import 'generated/conreality.pbgrpc.dart';

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
  final _items = List<String>.generate(5, (i) => "Item $i");

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: StartDrawer(),
      body: FutureBuilder<HelloResponse>(
        future: _connect(),
        builder: (final BuildContext context, final AsyncSnapshot<HelloResponse> snapshot) {
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
                return Text('Error: ${snapshot.error}');
              }
              //final HelloResponse response = snapshot.data; // TODO: response.list
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_items[index]}'),
                  );
                },
              );
          }
          assert(false, "unreachable");
          return null; // unreachable
        },
      ),
    );
  }

  Future<HelloResponse> _connect() async {
    final creds = gRPC.ChannelCredentials.insecure();
    final channel = gRPC.ClientChannel('10.0.2.2', port: 50051, // FIXME
      options: gRPC.ChannelOptions(credentials: creds));
    final stub = MasterClient(channel);
    final name = 'Flutter';
    try {
      return await stub.hello(HelloRequest()..name = name);
    }
    finally {
      channel.shutdown();
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
        title: Text('Chat'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return ChatScreen(title: 'Demo Chat'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text('Compass'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return CompassScreen(title: 'Demo Compass'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.gamepad),
        title: Text('Game'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return GameScreen(game: Game(title: 'Demo Game')); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text('Map'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return MapScreen(title: 'Demo Map'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.report),
        title: Text('Send feedback'),
        onTap: () {
          launch('https://github.com/conreality/conreality-player/issues/new');
        },
      ),

      AboutListTile(
        icon: FlutterLogo(), // TODO
        applicationVersion: 'September 2018',
        applicationIcon: FlutterLogo(), // TODO
        applicationLegalese: 'This is free and unencumbered software released into the public domain.',
        aboutBoxChildren: <Widget>[],
      ),
    ];
    return Drawer(child: ListView(primary: false, children: allDrawerItems));
  }
}
