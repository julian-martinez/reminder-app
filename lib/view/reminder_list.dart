import 'package:flutter/material.dart';
import '../i18n.dart';
import 'new_reminder.dart';
import '../dependency_injection.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttery/framing.dart';

class ReminderList extends StatefulWidget {
  ReminderList({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _ReminderListState createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {

  void _signOut(BuildContext context) async {
    await Injector().auth.signOut();
    if (!Navigator.pop(context)){
      Navigator.of(context).pushNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              _signOut(context);
            }
        ),
        title: new Text(I18n.of(context).getValueOf(Strings.REMINDERS)),
      ),
      body: new ListView.builder(
        itemCount: 15,
        itemBuilder: (context, i){
          return new Column(
            children: <Widget>[
              new ReminderItem(),
              new Divider(color: Colors.lightBlueAccent, height: 2.0,)
            ],
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Reminder(user: widget.user,)
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReminderItem extends StatefulWidget {
  @override
  _ReminderItemState createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            //flex: 1,
            child: new Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 9.0, top: 8.0, bottom: 8.0),
              child: new Container(
                width: 48.0,
                height: 48.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent
                ),
                child: new Stack(
                  children: <Widget>[
                    new Align(
                      widthFactor: 3.0,
                      heightFactor: 3.0,
                      child: new Text('26',
                        style : new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.black
                        ),
                      ),
                    ),
                    new Positioned(
                      top: 28.0,
                      left: 8.0,
                        child: new Text('sep.',
                          style : new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black
                          ),
                        ),
                    ),
                    new Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: new Icon(
                        Icons.add_alert,
                        color: Colors.grey,
                        size: 18.0,
                      ),
                    )
                  ],
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
                  child: new Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                new Container(
                  alignment: Alignment.centerRight,
                  height: 24.0,
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 2.0),
                  child: new Text('03/09/2018 17:37',
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
              child: new Icon(Icons.gps_fixed, color: Colors.grey,),
            ),
          ),
        ],
      )
    );

  }
}

