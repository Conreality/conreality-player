/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'api.dart' as API;
import 'cache.dart';
import 'spinner.dart';
import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class ChatTab extends StatefulWidget {
  ChatTab({Key key, this.title, this.client}) : super(key: key);

  final API.Client client;
  final String title;

  @override
  State<ChatTab> createState() => ChatState();
}

////////////////////////////////////////////////////////////////////////////////

class ChatState extends State<ChatTab> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  Future<List<Message>> _data;

  @override
  void initState() {
    super.initState();
    _data = Future.sync(() => _load());
  }

  Future<List<Message>> _load() async {
    final Cache cache = await Cache.instance;
    return cache.fetchMessages();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _data,
      builder: (final BuildContext context, final AsyncSnapshot<List<Message>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Spinner();
          case ConnectionState.done: {
            if (snapshot.hasError) return Text(snapshot.error.toString()); // GrpcError
            return Column(
              children: <Widget>[
                Flexible(child: ChatMessageHistory(messages: snapshot.data)),
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
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
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

  void _handleSubmitted(final String text) async {
    _textController.clear();

    final Message message = Message(text: text);

    ChatMessage messageWidget = ChatMessage(message: message);
    setState(() { _messages.insert(0, messageWidget); });

    widget.client.sendMessage(API.Message()..text = text);

    final Cache cache = await Cache.instance;
    await cache.sendMessage(API.Message()..text = text);
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessageHistory extends StatelessWidget {
  final List<Message> messages;

  ChatMessageHistory({this.messages});

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (_, int index) {
        return ChatMessage(message: messages[index]);
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessage extends StatelessWidget {
  final Message message;

  ChatMessage({this.message});

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text("I")), // TODO
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Me", style: Theme.of(context).textTheme.subhead), // TODO
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(message.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
