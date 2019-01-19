/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'share_tab.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class ShareScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).share),
        actions: <Widget>[],
      ),
      body: ShareTab(gameURL: "TODO"/*game.url.toString()*/), // FIXME
    );
  }
}
