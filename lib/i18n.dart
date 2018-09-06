import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

class I18n {
  I18n(this._locale);

  Locale _locale;

  static I18n of(BuildContext context){
    return Localizations.of<I18n>(context, I18n);
  }

  static Map<String, Map<Strings, String>> _localizedValues = {
    'en': {
      Strings.FORM_EMAIL: 'E-Mail',
      Strings.FORM_PASSWORD: 'Password',
      Strings.BTN_LOGIN: 'Log in',
      Strings.NEW_REMINDER: 'New reminder',
      Strings.WRT_REMINDER: 'Write your reminder',
      Strings.NOTIFY_AT: 'Notify at',
      Strings.SAVED_LOCATION: 'Saved location',
      Strings.REMINDER: 'Reminder',
      Strings.REMINDERS: 'Reminders',
      Strings.VAL_EMAIL: 'Email not valid',
      Strings.VAL_PASS: 'Password is too short',
      Strings.VAL_REPASS: 'Both passwords are not equals',
      Strings.ERROR: 'Error',
      Strings.ERROR_LOGIN: 'Unexpected error happened at the login process',
      Strings.ERROR_REGISTER: 'Unexpected error happened at the register process',
      Strings.VERIFY_TITLE: 'We are almost done',
      Strings.VERIFY_MESSAGE: 'In order to finish the register, we sended you an email with a link to activate your account. Please, check your inbox',
      Strings.BTN_OK: 'Ok',
      Strings.BTN_RESEND_MAIL: 'Resend email',
      Strings.BTN_NO: 'No',
      Strings.BTN_YES: 'Yes',
      Strings.BTN_CANCEL: 'Cancel',
      Strings.BTN_CONTINUE: 'Continue',
      Strings.DLGT_LOST_PASS: 'Incorrect password',
      Strings.DLGM_LOST_PASS: 'The password is not correct, ¿Do you want us to send you an email to recover it back?',
      Strings.DLGT_SEND_EMAIL: 'Email sended',
      Strings.DLGM_SEND_EMAIL: 'Please, check your inbox',
      Strings.DLGT_COMPLETE_REGISTER: 'Complete your registry',
      Strings.FORM_REPASSWORD: 'Repeat your password',
      Strings.NO_CONTENT: 'You don\'t have any reminder. Tap on the bottom button to add a new one.',
      Strings.SCHED_NOTIFICATION: 'Scheduled notification',
      Strings.RM_REMINDER: 'Reminder removed',
      Strings.LOADING_CONTENT: 'Loading content',
      Strings.DLGT_EXIT: 'Exit',
      Strings.DLGM_EXIT: 'Do you want to exit the application?',

    },
    'es': {
      Strings.FORM_EMAIL: 'Correo electrónico',
      Strings.FORM_PASSWORD: 'Contraseña',
      Strings.BTN_LOGIN: 'Acceder',
      Strings.NEW_REMINDER: 'Nuevo recordatorio',
      Strings.WRT_REMINDER: 'Escribe tu recordatorio',
      Strings.NOTIFY_AT: 'Notificar en',
      Strings.SAVED_LOCATION: 'Localización guardada',
      Strings.REMINDER: 'Recordatorio',
      Strings.REMINDERS: 'Recordatorios',
      Strings.VAL_EMAIL: 'Email no válido',
      Strings.VAL_PASS: 'La contraseña es demasiado corta',
      Strings.VAL_REPASS: 'Las contraseñas no son iguales',
      Strings.ERROR: 'Error',
      Strings.ERROR_LOGIN: 'Ha ocurrido un error inesperado en el proceso de inicio de sesión',
      Strings.ERROR_REGISTER: 'Ha ocurrido un error inesperado en el proceso de registro',
      Strings.VERIFY_TITLE: 'Ya casí está',
      Strings.VERIFY_MESSAGE: 'Para completar registro, te hemos enviado un email con un enlace para activar tu cuenta. Por favor, revisa tu bandeja de entrada',
      Strings.BTN_OK: 'Vale',
      Strings.BTN_RESEND_MAIL: 'Reenviar email',
      Strings.BTN_NO: 'No',
      Strings.BTN_YES: 'Sí',
      Strings.BTN_CANCEL: 'Cancelar',
      Strings.BTN_CONTINUE: 'Continuar',
      Strings.DLGT_LOST_PASS: 'Contraseña incorrecta',
      Strings.DLGM_LOST_PASS: 'La contraseña introducida no es correcta, ¿Te enviamos un email para recuperarla?',
      Strings.DLGT_SEND_EMAIL: 'Email reenviado',
      Strings.DLGM_SEND_EMAIL: 'Por favor, revisa tu bandeja de entrada',
      Strings.DLGT_COMPLETE_REGISTER: 'Completa tu registro',
      Strings.FORM_REPASSWORD: 'Repite tu contraseña',
      Strings.NO_CONTENT: 'No tienes ningún recordatorio. Pulsa en el botón inferior para añadir uno nuevo.',
      Strings.SCHED_NOTIFICATION: 'Notificación programada',
      Strings.RM_REMINDER: 'Recordatorio eliminado',
      Strings.LOADING_CONTENT: 'Cargando contenido',
      Strings.DLGT_EXIT: 'Salir',
      Strings.DLGM_EXIT: '¿Quieres salir de la aplicación?',

    }
  };

  String getValueOf(Strings value) {
    return _localizedValues[_locale.languageCode][value];
  }

  String get locale => _locale.toString();
}

enum Strings {
  FORM_EMAIL,
  FORM_PASSWORD,
  BTN_LOGIN,
  NEW_REMINDER,
  WRT_REMINDER,
  NOTIFY_AT,
  SAVED_LOCATION,
  REMINDER,
  REMINDERS,
  VAL_EMAIL,
  VAL_PASS,
  VAL_REPASS,
  ERROR,
  ERROR_LOGIN,
  ERROR_REGISTER,
  VERIFY_TITLE,
  VERIFY_MESSAGE,
  BTN_OK,
  BTN_RESEND_MAIL,
  BTN_NO,
  BTN_YES,
  BTN_CANCEL,
  BTN_CONTINUE,
  DLGT_LOST_PASS,
  DLGM_LOST_PASS,
  DLGT_SEND_EMAIL,
  DLGM_SEND_EMAIL,
  DLGT_COMPLETE_REGISTER,
  FORM_REPASSWORD,
  NO_CONTENT,
  SCHED_NOTIFICATION,
  RM_REMINDER,
  LOADING_CONTENT,
  DLGT_EXIT,
  DLGM_EXIT,
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