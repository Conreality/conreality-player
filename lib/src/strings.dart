/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart' show BuildContext, Localizations, LocalizationsDelegate;

import 'generated/strings.dart' show GeneratedStrings;

////////////////////////////////////////////////////////////////////////////////

class StringsDelegate extends LocalizationsDelegate<Strings> {
  final Set<String> supportedLanguageCodes;

  StringsDelegate() :
    supportedLanguageCodes = GeneratedStrings.supportedLocales.map((locale) => locale.languageCode).toSet();

  @override
  bool isSupported(final Locale locale) => supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<Strings> load(final Locale locale) {
    return SynchronousFuture<Strings>(Strings(locale));
  }

  @override
  bool shouldReload(final StringsDelegate _) => false;
}

////////////////////////////////////////////////////////////////////////////////

class Strings extends GeneratedStrings {
  Strings(final Locale locale) : super(locale, GeneratedStrings.supportedLocales.first);

  static Strings of(final BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  String get todo => "TODO";
}
