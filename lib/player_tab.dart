/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class PlayerTab extends StatefulWidget {
  PlayerTab({Key key, this.info}) : super(key: key);

  final API.GameInformation info;

  @override
  State<PlayerTab> createState() => PlayerState();
}
////////////////////////////////////////////////////////////////////////////////

class PlayerState extends State<PlayerTab> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /*ExpansionTile(
              title: Text("Mission", overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              initiallyExpanded: true,
              children: <Widget>[
                ListTile(
                  title: Text(widget.info.title),
                  subtitle: Text(widget.info.mission),
                ),
                Container(padding: EdgeInsets.only(bottom: 16.0)),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
