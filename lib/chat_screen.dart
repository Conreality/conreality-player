/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'chat_tab.dart';

////////////////////////////////////////////////////////////////////////////////

class ChatScreen extends StatelessWidget {
  ChatScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
        ],
      ),
      body: ChatTab(),
    );
  }
}
