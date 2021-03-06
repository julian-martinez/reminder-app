import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../i18n.dart';
import '../dependency_injection.dart';
import '../model/reminder.dart';
import 'new_reminder.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fluttery/framing.dart';

class ReminderList extends StatefulWidget {
  ReminderList({Key key, @required this.user}) : super(key: key);

  FirebaseUser user;

  @override
  _ReminderListState createState() => _ReminderListState(user);
}

class _ReminderListState extends State<ReminderList> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<ReminderData> _reminderList = new List();
  DatabaseReference _mainReference;
  bool _isFloatingButtonEnabled;

  _ReminderListState(FirebaseUser user){
    _mainReference = Injector().database.reference().child('users').child(user.uid).child('reminders').reference();
    _mainReference.onChildAdded.listen(_onEntryAdded);
    //_mainReference.onChildChanged.listen(_onEntryUpdated);
  }

  _onEntryAdded(Event event){
    bool active = event.snapshot.value['active'];
    if (active)
    setState(() {
      _reminderList.add(new ReminderData.fromSnapshot(event.snapshot));
    });
  }

  _onEntryUpdated(Event event){
    var oldValue = _reminderList.singleWhere((entry) => entry.id == event.snapshot.key);
    setState(() {
      _reminderList[_reminderList.indexOf(oldValue)] = new ReminderData.fromSnapshot(event.snapshot);
    });
  }

  ReminderData findByKey(List<ReminderData> list, String key){
    return list.firstWhere((item) => item.id == key);
  }

  void _signOut(BuildContext context) async {
    await Injector().auth.signOut();
    if (!Navigator.pop(context)){
      Navigator.of(context).pushNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _isFloatingButtonEnabled = true;

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    /*
    var reminder = findByKey(_reminderList, payload);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Reminder(
          user: widget.user,
          reminderText: reminder.text,
          existentNotification: reminder.notificationDate,
        )
    ));
    */
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(I18n.of(context).getValueOf(Strings.DLGT_EXIT)),
        content: new Text(I18n.of(context).getValueOf(Strings.DLGM_EXIT)),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(I18n.of(context).getValueOf(Strings.BTN_NO)),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(I18n.of(context).getValueOf(Strings.BTN_YES)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_reminderList != null){
      _reminderList.sort((a,b) {
        if (a.notificationDate != null){
          if (b.notificationDate != null) return a.notificationDate.compareTo(b.notificationDate);
          else return -1;
        } else {
          if (b.notificationDate != null) return 1;
          else return a.creationDate.compareTo(b.creationDate);
        }
      });
    }

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: (){
                  _signOut(context);
                }
            ),
            title: new Text(I18n.of(context).getValueOf(Strings.REMINDERS)),
          ),
          body: displayContent(_reminderList),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _isFloatingButtonEnabled ? new FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Reminder(user: widget.user,)
              ));
            },
            child: const Icon(Icons.add),
          )
              : null,
        )
    );
  }

  Widget displayContent(List<ReminderData> reminderList){
    if (reminderList == null){
        return new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new Text(I18n.of(context).getValueOf(Strings.LOADING_CONTENT)),
              ),
            ],
          ),
        );
    } else {
      if (reminderList.isEmpty){
        return new Center(
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.event_note, size: 64.0,),
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(I18n.of(context).getValueOf(Strings.NO_CONTENT),
                      style: new TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
        );
      } else {
        return new ListView.builder(
            itemCount: reminderList.length,
            itemBuilder: (context, i) {
              return new Dismissible(
                  background: Container(
                      height: 48.0,
                      alignment: Alignment.center,
                      color: Colors.lightBlueAccent,
                      child: const ListTile(
                          leading: Icon(Icons.delete, color: Colors.white, size: 36.0)
                      )
                  ),
                  direction: DismissDirection.startToEnd,
                  key: new ObjectKey(reminderList[i]),
                  onDismissed: (direction) {
                    if (reminderList.contains(reminderList[i])){
                      _mainReference.child(reminderList[i].id).reference().update({
                        'active': false
                      });

                      int notificationId = reminderList[i].creationDate.millisecondsSinceEpoch - Injector().baseTimeIdGenerator;
                      flutterLocalNotificationsPlugin.cancel(notificationId);
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text(I18n.of(context).getValueOf(Strings.RM_REMINDER))));

                      setState(() {
                        reminderList.remove(reminderList[i]);
                      });
                    }
                  },
                  child: new Column(
                    children: <Widget>[
                      new ReminderItem(reminderList[i], widget.user),
                      new Divider(color: Colors.lightBlueAccent, height: 1.0,)
                    ],
                  )


              );
            }
        );
      }
    }
  }

}

class ReminderItem extends StatefulWidget {
  ReminderItem(this.data, this.user);

  final ReminderData data;
  final FirebaseUser user;

  @override
  _ReminderItemState createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  @override
  Widget build(BuildContext context) {
    ReminderData _data = widget.data;

    return new InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Reminder(
              user: widget.user,
              reminderText: _data.text,
              existentNotification: _data.notificationDate,
            )
        ));
      },
      child: new Container(
          child: new Row(
            children: <Widget>[
              new Container(
                //flex: 1,
                child: new Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 1.0,),
                  child: new Container(
                      width: 52.0,
                      height: 52.0,
                      child: new Stack(
                          children: _notificationIconContent(_data)
                      )
                  ),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 24.0,
                      padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 4.0),
                      child: new Text(_data.text.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    new Container(
                      alignment: Alignment.centerRight,
                      height: 24.0,
                      padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 2.0),
                      child: new Text(new DateFormat.yMMMd(I18n.of(context).locale).add_Hm().format(_data.creationDate),
                        style: new TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                //flex: 1,
                child: new Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0, bottom: 18.0),
                  child: _data.hasLatLon ? new Icon(Icons.gps_fixed, color: Colors.grey,) : new Container(width: 24.0, height: 24.0,),
                ),
              ),
            ],
          )
      )
    );
  }


  List<Widget> _notificationIconContent(ReminderData _data){
    List<Widget> list;
    if (_data.notificationDate != null){
      list = [
        new Align(
          alignment: Alignment.center,
          child: new Container(
            width: 48.0,
            height: 48.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent
            ),
          ),
        ),
        new Align(
          alignment: Alignment(0.0, -0.2),
          child: new Text(new DateFormat('dd').format(_data.notificationDate),
            style : new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
                color: Colors.black
            ),
          ),
        ),
        new Align(
          alignment: Alignment(0.2, 0.8),
          child: new Text(new DateFormat.MMM(I18n.of(context).locale).format(_data.notificationDate),
            style : new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black
            ),
          ),
        ),
        new Align(
          alignment: Alignment.topRight,
          child: new Icon(
            Icons.notifications_active,
            color: Colors.deepOrange,
            size: 20.0,
          ),
        )
      ];
    } else {
      list = [
        new Align(
          alignment: Alignment.center,
          child: new Container(
            width: 48.0,
            height: 48.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent
            ),
          ),
        ),
        new Align(
          alignment: Alignment.topRight,
          child: new Icon(
            Icons.notifications_off,
            color: Colors.deepOrange,
            size: 20.0,
          ),
        )
      ];
    }
    return list;
  }

}

