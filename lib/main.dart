import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n.dart';
import 'dependency_injection.dart';

import 'view/login.dart';

import 'view/new_reminder.dart';
import 'view/reminder_list.dart';

import 'package:firebase_auth/firebase_auth.dart';

void main() {
  Injector.configure(Flavor.PROD);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
        //'/reminders': (context) => ReminderList()
      },
      localizationsDelegates: [
        I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      title: 'Flutter Demo',
      theme: new ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: new Home(title: ''),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _isLoggedIn;
  FirebaseUser _user;

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? ReminderList(user: _user,) : Login();
  }

  @override
  void initState() {
    _isLoggedIn = false;
    Injector().auth.currentUser().then((user) {
      if (user != null && user.isEmailVerified){
        setState(() {
          _isLoggedIn = true;
          _user = user;
        });
      }
    });
    super.initState();
  }
}

