/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

class GameDrawer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[
/*
      Divider(),

      ListTile(
        leading: Icon(Icons.contacts),
        title: Text(Strings.of(context).team),
        onTap: () {
          Navigator.of(context).pushNamed('/team');
        },
      ),

      ListTile(
        leading: Icon(Icons.chat),
        title: Text(Strings.of(context).chat),
        onTap: () {
          Navigator.of(context).pushNamed('/chat');
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text(Strings.of(context).compass),
        onTap: () {
          Navigator.of(context).pushNamed('/compass');
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text(Strings.of(context).map),
        onTap: () {
          Navigator.of(context).pushNamed('/map');
        },
      ),
*/

      Divider(),

      ListTile(
        leading: Icon(Icons.report),
        title: Text(Strings.of(context).sendFeedback),
        onTap: () {
          launch(Strings.of(context).feedbackURL);
        },
      ),

      AboutListTile(
        icon: FlutterLogo(), // TODO
        applicationVersion: Strings.of(context).appVersion,
        applicationIcon: FlutterLogo(), // TODO
        applicationLegalese: Strings.of(context).legalese,
        aboutBoxChildren: <Widget>[],
      ),
    ];
    return Drawer(child: ListView(primary: false, children: allDrawerItems));
  }
}
