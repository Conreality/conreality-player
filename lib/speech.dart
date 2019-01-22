/* This is free and unencumbered software released into the public domain. */

import 'package:flutter_tts/flutter_tts.dart' show FlutterTts;

////////////////////////////////////////////////////////////////////////////////

final FlutterTts _tts = FlutterTts();

////////////////////////////////////////////////////////////////////////////////

Future<void> say(final String text) async {
  assert(text != null);
  await _tts.speak(text);
}
