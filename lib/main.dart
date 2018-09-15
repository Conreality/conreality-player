/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'start.dart';

void main() => runApp(PlayerApp());

////////////////////////////////////////////////////////////////////////////////

class PlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conreality Player',
      color: Colors.grey,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: StartScreen(title: 'Conreality Player'),
    );
  }
}
