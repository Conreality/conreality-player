/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

////////////////////////////////////////////////////////////////////////////////

class Spinner extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.grey,
        size: 300.0,
      ),
    );
  }
}
