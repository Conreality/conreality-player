/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api.dart' as API;
import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class ChatTab extends StatefulWidget {
  ChatTab({Key key, this.title, this.client}) : super(key: key);

  final API.Client client;
  final String title;

  @override
  ChatState createState() => ChatState();
}

////////////////////////////////////////////////////////////////////////////////

class ChatState extends State<ChatTab> {
  static const platform = MethodChannel('app.conreality.org/chat');

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: Strings.of(context).sendMessage,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(final String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(text: text);
    setState(() { _messages.insert(0, message); });
    widget.client.sendMessage(API.Message()..text = text);
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text("I")),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Me", style: Theme.of(context).textTheme.subhead),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
