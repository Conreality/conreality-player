/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'keys.dart' show refreshPlayerScreenKey;
import 'player_screen.dart' show PlayerScreen;

import 'src/client.dart' show Client;
import 'src/model.dart' show Message, Player;
import 'src/player_avatar.dart' show PlayerAvatar;
import 'src/session.dart' show GameSession;
import 'src/spinner.dart' show Spinner;
import 'src/speech.dart' show say;
import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

class ChatTab extends StatefulWidget {
  final GameSession session;

  ChatTab({Key key, @required this.session})
    : assert(session != null),
      super(key: key);

  @override
  State<ChatTab> createState() => ChatTabState();
}

////////////////////////////////////////////////////////////////////////////////

class ChatTabState extends State<ChatTab> {
  final TextEditingController _textController = TextEditingController();
  List<Message> _messages;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() async {
    final GameSession session = widget.session;
    final List<Message> messages = await session.cache.fetchMessages();
    setState(() {
      _messages = messages;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final GameSession session = widget.session;
    return (_messages == null) ? Spinner() : Column(
      children: <Widget>[
        Flexible(child: ChatMessageHistory(session: session, messages: _messages)),
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

    _textController.clear();

    final GameSession session = widget.session;
    final Player player = await session.cache.getPlayer(session.playerID);
    final Message message = Message(
      sender: player.id,
      recipient: null, // everyone
      language: player.language,
      text: text,
    );

    final Client client = Client(widget.session.connection);
    print(message.toRPC().writeToJson());
    client.rpc.sendMessage(message.toRPC());

    // TODO: support message status indicators:
    //await cache.putMessage(message.toRPC());
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessageHistory extends StatelessWidget {
  final GameSession session;
  final List<Message> messages;

  ChatMessageHistory({@required this.session, this.messages})
    : assert(session != null);

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (_, final int index) {
        return ChatMessage(session: session, message: messages[index]);
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatMessage extends StatelessWidget {
  final GameSession session;
  final Message message;

  ChatMessage({@required this.session, this.message})
    : assert(session != null);

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle timestampStyle = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color, fontSize: 12.0);
    final Image appIcon = Image.asset("assets/icon.png");
    return ListTile(
      leading: GestureDetector(
        child: message.isSystem ? appIcon : PlayerAvatar(session: session, playerID: message.sender),
        onTap: message.isSystem ? null : () async {
          assert(message.hasSender);
          final Player sender = await session.cache.getPlayer(message.sender);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final BuildContext context) {
                return PlayerScreen(key: refreshPlayerScreenKey, session: session, playerID: sender.id);
              }
            )
          );
        },
      ),
      title: Row(
        children: <Widget>[
          Text(session.cache.getName(message.sender) ?? "Unknown", style: Theme.of(context).textTheme.subhead),
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
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: message.text));
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Message text copied to clipboard.", textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
