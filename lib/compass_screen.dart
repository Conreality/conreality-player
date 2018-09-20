/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'compass_tab.dart';

////////////////////////////////////////////////////////////////////////////////

class CompassScreen extends StatelessWidget {
  CompassScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[],
      ),
      body: CompassTab(),
    );
  }
}
