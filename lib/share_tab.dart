/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'src/strings.dart';

////////////////////////////////////////////////////////////////////////////////

class ShareTab extends StatelessWidget {
  final String gameURL;

  ShareTab({Key key, this.gameURL}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    assert(this.gameURL != null);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: QrImage(data: this.gameURL ?? "", size: 300.0),
            ),
            Container(
              width: 300.0,
              padding: EdgeInsets.all(16.0),
              child: Text(
                Strings.of(context).scanThisWithAnotherDevice,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
