import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../i18n.dart';
import '../dependency_injection.dart';
import '../ui/date_time_picker.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:fluttery/framing.dart';

class Reminder extends StatefulWidget {
  Reminder({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool _activeNotification;
  bool _activeLocation;
  double _lat;
  double _lon;
  DateTime _ntDate;
  TimeOfDay _ntTime;

  final reminderController = new TextEditingController();

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
      builder: (_) => new AlertDialog(
        title: const Text(''),
        content: new Text('$payload'),
      ),
    );
  }

  Future _showNotificationWithDefaultSound(int id, DateTime scheduledDateTime, String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'com.easyoneapps.reminder', 'reminder-app', 'reminder-desc',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      id,
      I18n.of(context).getValueOf(Strings.SCHED_NOTIFICATION),
      message,
      scheduledDateTime,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  @override
  void initState() {
    super.initState();
    _activeNotification = false;
    _activeLocation = false;
    _ntDate = new DateTime.now();
    _ntTime = TimeOfDay.fromDateTime(_ntDate);

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, selectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    reminderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    FirebaseUser _user = widget.user;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back), 
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: new Text(I18n.of(context).getValueOf(Strings.NEW_REMINDER)),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new TextFormField(
                    controller: reminderController,
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 255,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: I18n.of(context).getValueOf(Strings.WRT_REMINDER),
                    )
                  )
              ),
            ),
          activateNotification(_activeNotification),
          activateLocation(_activeLocation),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          String trimmedText = reminderController.text.toString().trim();
          DateTime notification = new DateTime(_ntDate.year, _ntDate.month, _ntDate.day, _ntTime.hour, _ntTime.minute);
          DateTime creation = DateTime.now();
          if (notification.isBefore(creation)) notification = null;

          Injector().database.reference().child(_user.uid).child('reminders').reference().push().set({
            'text': trimmedText,
            'creation': creation.toString(),
            'notification': notification?.toString(),
            'active': true
          });

          if (notification != null) {
            int notificationId = creation.millisecondsSinceEpoch - Injector().baseTimeIdGenerator;
            String notificationMessage = trimmedText.length < 50 ? trimmedText : trimmedText.substring(0, 49) + '...';
            _showNotificationWithDefaultSound(notificationId, notification, notificationMessage);
          }

          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
      bottomNavigationBar: new BottomAppBar(
        hasNotch: true,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /* LOCATION FEATURE (temporarily disabled)
            new Padding(
              padding: const EdgeInsets.only(left:24.0, right: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.gps_fixed),
                color: _activeLocation ? Colors.lightBlue : Colors.black,
                onPressed: (){
                  setState(() {
                    _activeLocation = !_activeLocation;
                    _lat = _activeLocation ? 39.5 : null;
                    _lon = _activeLocation ? 2.5 : null;
                  });
                  activateLocation(_activeLocation);
                }
              ),
            ),
            */
            new Padding(
              padding: const EdgeInsets.only(left:4.0, right: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.add_alert),
                  color: _activeNotification ? Colors.lightBlue : Colors.black,
                  onPressed: (){
                    setState(() {
                      _activeNotification = !_activeNotification;
                    });
                    activateNotification(_activeNotification);
                  }
              )
            ),
          ],
        )
      ),
    );
  }

  Widget activateNotification(bool activeNotification){
    if (activeNotification){
      return new Container(
        child: new Row(
          children: <Widget>[
            new Flexible(
                child: new Container(),
              flex: 1,
            ),
            new Flexible(
              child: new DateTimePicker(
                labelText: I18n.of(context).getValueOf(Strings.NOTIFY_AT),
                selectedDate: _ntDate,
                selectedTime: _ntTime,
                selectDate: (DateTime date){
                  setState(() {
                    _ntDate = date;
                  });
                },
                selectTime: (TimeOfDay time){
                  setState(() {
                    _ntTime = time;
                  });
                },
              ),
              flex: 12
            ),
            new Flexible(
                child: new Container(),
              flex: 4,
            ),
          ],
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget activateLocation(bool activeLocation){
    if (activeLocation){
      return new Row(
        children: <Widget>[
          new Expanded(
              child: new Container(
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 12.0),
                alignment: Alignment.centerLeft,
                  child: new Text(I18n.of(context).getValueOf(Strings.SAVED_LOCATION), style: TextStyle(fontSize: 18.0),)
              )
          )
        ],
      );
    } else {
      return new Container();
    }
  }

}

class SecondScreen extends StatefulWidget {
  final String payload;
  SecondScreen(this.payload);
  @override
  State<StatefulWidget> createState() => new SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Screen with payload: " + _payload),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}

