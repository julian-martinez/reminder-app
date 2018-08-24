import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n of(BuildContext context){
    return Localizations.of<I18n>(context, I18n);
  }


  static Map<String, Map<Strings, String>> _localizedValues = {
    'en': {
      Strings.FORM_EMAIL: 'E-Mail',
      Strings.FORM_PASSWORD: 'Password',
      Strings.BTN_LOGIN: 'Log in'
    },
    'es': {
      Strings.FORM_EMAIL: 'Correo electrónico',
      Strings.FORM_PASSWORD: 'Contraseña',
      Strings.BTN_LOGIN: 'Acceder'
    }
  };


  String getValueOf(Strings value) {
    return _localizedValues[locale.languageCode][value];
  }
}

enum Strings {
  FORM_EMAIL,
  FORM_PASSWORD,
  BTN_LOGIN
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) => false;

  @override
  Future<I18n> load(Locale locale) => SynchronousFuture<I18n>(I18n(locale));

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);
}