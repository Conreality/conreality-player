/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'api.dart' as API;
import 'cache.dart';
import 'speech.dart' show say;
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
  Cache _cache;

  @override
  void initState() {
    super.initState();
    _data = Future.sync(() => _load());
  }

  Future<List<Message>> _load() async {
    _cache = await Cache.instance;
    return _cache.fetchMessages();
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
                Flexible(child: ChatMessageHistory(cache: _cache, messages: snapshot.data)),
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
                textInputAction: TextInputAction.send,
                onChanged: (_) { setState(() {}); },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _textController.text.isEmpty ? null : () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(final String text) async {
    if (text.isEmpty) return;

    setState(() {
      _textController.clear();
    });

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
  final Cache cache;
  final List<Message> messages;

  ChatMessageHistory({this.cache, this.messages});

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (_, final int index) {
        return ChatMessage(cache: cache, message: messages[index]);
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessage extends StatelessWidget {
  final Cache cache;
  final Message message;

  ChatMessage({this.cache, this.message});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle timestampStyle = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color, fontSize: 12.0);
    return ListTile(
      leading: CircleAvatar(
        child: Text(senderInitials),
        backgroundColor: senderColor,
      ),
      title: Row(
        children: <Widget>[
          Text(sender, style: Theme.of(context).textTheme.subhead),
          Container(
            child: Text(timeago.format(message.timestamp), style: timestampStyle),
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
      subtitle: Text(message.text),
      trailing: GestureDetector(
        child: Icon(MdiIcons.playCircleOutline, color: Theme.of(context).disabledColor),
        onTap: () async {
          if (message.hasAudio) {
            // TODO: for audio messages, play the original audio stream.
          }
          else {
            await say(message.text, language: message.language);
          }
        },
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () {}, // TODO
      onLongPress: () {}, // TODO: select the message
    );
  }

  String get sender {
    return cache.getName(message.sender) ?? "Unknown";
  }

  String get senderInitials {
    return message.isSystem ? "" : cache.getName(message.sender).substring(0, 1);
  }

  Color get senderColor {
    return cache.getColor(message.sender);
  }
}
