/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'api.dart' as API;
import 'speech.dart' show say;

////////////////////////////////////////////////////////////////////////////////

class MissionTab extends StatefulWidget {
  MissionTab({Key key, this.client, this.info}) : super(key: key);

  final API.Client client;
  final API.GameInformation info;

  @override
  State<MissionTab> createState() => MissionState();
}
////////////////////////////////////////////////////////////////////////////////

class MissionState extends State<MissionTab> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Game not started yet", style: TextStyle(fontSize: 32.0)), // TODO: game state
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
            ),
            ExpansionTile(
              title: Text("Mission", overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              initiallyExpanded: true,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(widget.info.title ?? ""),
                        subtitle: Text(widget.info.mission ?? ""),
                      ),
                    ),
                    Column(
                      children: (widget.info.mission == null) ? <Widget>[] : <Widget>[
                        GestureDetector(
                          child: Icon(MdiIcons.playCircleOutline, color: Theme.of(context).disabledColor),
                          onTap: () async => await say(widget.info.mission),
                        ),
                      ],
                    ),
                    Container(padding: EdgeInsets.only(right: 16.0)),
                  ],
                ),
                Container(padding: EdgeInsets.only(bottom: 16.0)),
              ],
            ),
            ExpansionTile(
              title: Text("Theater", overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              initiallyExpanded: false,
              children: <Widget>[
                // TODO: origin, bounds, address, map?
                Container(padding: EdgeInsets.only(bottom: 16.0)),
              ],
            ),
            ExpansionTile(
              title: Text("Rules", overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              initiallyExpanded: false,
              children: <Widget>[
                // TODO: list of rules
                Container(padding: EdgeInsets.only(bottom: 16.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
