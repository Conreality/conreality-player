/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;

import '../speech.dart' show say;

////////////////////////////////////////////////////////////////////////////////

class TextSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String text;
  final bool initiallyExpanded;

  TextSection({this.title, this.subtitle, this.text, this.initiallyExpanded = false});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ExpansionTile(
      title: Text(title ?? "", overflow: TextOverflow.ellipsis),
      backgroundColor: theme.accentColor.withOpacity(0.025),
      initiallyExpanded: initiallyExpanded,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListTile( // TODO: better rendering with missing subtitle
                title: (subtitle != null) ? Text(subtitle ?? "") : SizedBox(height: 0, width: 0),
                subtitle: Text(text ?? ""),
                onLongPress: () {}, // TODO: copy text to clipboard
              ),
            ),
            Column(
              children: (text == null) ? <Widget>[] : <Widget>[
                GestureDetector(
                  child: Icon(MdiIcons.playCircleOutline, color: theme.disabledColor),
                  onTap: () async => await say(text),
                ),
              ],
            ),
            Container(padding: EdgeInsets.only(right: 16.0)),
          ],
        ),
        Container(padding: EdgeInsets.only(bottom: 16.0)),
      ],
    );
  }
}
