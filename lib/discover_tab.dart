/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'discover_error_body.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class DiscoverTab extends StatefulWidget {
  DiscoverTab({Key key}) : super(key: key);

  @override
  State<DiscoverTab> createState() => DiscoverState();
}

////////////////////////////////////////////////////////////////////////////////

class DiscoverState extends State<DiscoverTab> {
  //static const platform = MethodChannel('app.conreality.org/start');

  @override
  Widget build(final BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        final BuildContext context,
        final ConnectivityResult connectivity,
        final Widget child,
      ) {
        final bool isConnected = (connectivity == ConnectivityResult.wifi);
        return isConnected ? child : DiscoverErrorBody(error: Strings.of(context).connectToWiFiToJoin);
      },
      child: SpinKitRipple(color: Colors.grey, size: 300.0), // TODO
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
}
