/* This is free and unencumbered software released into the public domain. */

import 'dart:async';
import 'dart:math' as math;

import 'package:stream_transform/stream_transform.dart';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

////////////////////////////////////////////////////////////////////////////////

class CompassTab extends StatefulWidget {
  @override
  State<CompassTab> createState() => CompassState();
}

class CompassState extends State<CompassTab> {
  StreamSubscription<double> _subscription;
  double _direction;

  @override
  void initState() {
    super.initState();
    _subscription = FlutterCompass.events
      .transform(throttle(Duration(milliseconds: 250)))
      .listen((final double direction) {
        if (!mounted) return; // dispose() already called
        setState(() { _direction = direction; });
      });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey[700],
      child: Transform.rotate(
        angle: ((_direction ?? 0) * (math.pi / 180) * -1),
        child: Image.asset('assets/compass.png'),
      ),
    );
  }
}
