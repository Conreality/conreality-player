/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

////////////////////////////////////////////////////////////////////////////////

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ChatState createState() => ChatState();
}

////////////////////////////////////////////////////////////////////////////////

class ChatState extends State<ChatScreen> {
  static const platform = MethodChannel('app.conreality.org/chat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: _ignore),
        ],
      ),
      body: Center(
        child: Text('To be implemented.'), // TODO
      ),
    );
  }

  void _ignore() {}
}
