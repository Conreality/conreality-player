/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

Future<Uri> showConnectDialog(final BuildContext context, final String defaultURL) async {
  // TODO: defaultURL
  return showDialog<Uri>(
    context: context,
    barrierDismissible: true,
    builder: (final BuildContext context) => ConnectDialog()
  );
}

////////////////////////////////////////////////////////////////////////////////

class ConnectCanceled implements Exception {}

////////////////////////////////////////////////////////////////////////////////

class ConnectDialog extends StatefulWidget {
  ConnectDialog({Key key}) : super(key: key);

  @override
  ConnectState createState() => ConnectState();
}

////////////////////////////////////////////////////////////////////////////////

class ConnectState extends State<ConnectDialog> {
  Uri _url;

  void _setURL(final Uri value) {
    setState(() {
      _url = value;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: Text(Strings.connectToGame),
      content: TextField(
        decoration: InputDecoration(
          labelText: Strings.enterGameURL,
        ),
        maxLength: 128,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.go,
        autofocus: true,
        autocorrect: false,
        onChanged: (String value) {
          _setURL((value != null && value.trim().length > 0) ? Uri.tryParse(value) : null);
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(Strings.cancel.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        new FlatButton(
          child: Text(Strings.connect.toUpperCase()),
          onPressed: (_url == null) ? null : () => Navigator.of(context).pop(_url),
        ),
      ],
    );
  }
}
