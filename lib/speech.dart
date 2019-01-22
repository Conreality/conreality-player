/* This is free and unencumbered software released into the public domain. */

import 'package:flutter_tts/flutter_tts.dart' show FlutterTts;

////////////////////////////////////////////////////////////////////////////////

final FlutterTts _tts = FlutterTts();

////////////////////////////////////////////////////////////////////////////////

Future<void> say(final String text, {final String language}) async {
  assert(text != null);

  final String lang = (language != null && await _tts.isLanguageAvailable(language)) ? language : "en-US";
  await _tts.setLanguage(lang);

  await _tts.speak(text);
}
