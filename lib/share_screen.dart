/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'share_tab.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class ShareScreen extends StatelessWidget {
  final String gameURL;

  ShareScreen({Key key, this.gameURL}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    assert(this.gameURL != null);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).share),
        actions: <Widget>[],
      ),
      body: ShareTab(gameURL: this.gameURL),
    );
  }
}
