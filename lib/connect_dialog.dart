/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'strings.dart';

////////////////////////////////////////////////////////////////////////////////

Future<Uri> showConnectDialog(final BuildContext context, final String defaultURL) async {
  return showDialog<Uri>(
    context: context,
    barrierDismissible: true,
    builder: (final BuildContext context) => ConnectDialog(defaultURL: defaultURL)
  );
}

////////////////////////////////////////////////////////////////////////////////

class ConnectCanceled implements Exception {}

////////////////////////////////////////////////////////////////////////////////

class ConnectDialog extends StatefulWidget {
  ConnectDialog({Key key, this.defaultURL}) : super(key: key);

  final String defaultURL;

  @override
  ConnectState createState() => ConnectState();
}

////////////////////////////////////////////////////////////////////////////////

class ConnectState extends State<ConnectDialog> {
  Uri _url;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _url = Uri.tryParse(widget.defaultURL);
    _controller.text = widget.defaultURL;
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    final String value = _controller.text;
    setState(() {
      _url = (value != null && value.trim().length > 0) ? Uri.tryParse(value) : null;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: Text(Strings.of(context).connectToGame),
      content: TextField(
        decoration: InputDecoration(
          labelText: Strings.of(context).enterGameURL,
        ),
        controller: _controller,
        maxLength: 128,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.go,
        autofocus: true,
        autocorrect: false,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(Strings.of(context).cancel.toUpperCase()),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        new FlatButton(
          child: Text(Strings.of(context).connect.toUpperCase()),
          onPressed: (_url == null) ? null : () => Navigator.of(context).pop(_url),
        ),
      ],
    );
  }
}
