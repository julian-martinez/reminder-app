import 'package:flutter/material.dart';

class ReminderItem {
/*
  String _id;
  ReminderData _data;

  ReminderItem(this._id, this._data);

  ReminderItem.map(dynamic obj){
    this._id = obj['id'];
    this._data = obj['text'];
  }

  String get id => _id;
  ReminderData get data => _data;

  Map<String, ReminderData> toMap(){
    var map = new Map<String, ReminderData>();
    map['id'] = _data.toMap();
    return map;
  }

  ReminderData.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._text = map['text'];
  }
  */
}

class ReminderData extends StatelessWidget{

  String _id;
  String _text;
  DateTime _creationDate;
  DateTime _notificationDate;
  double _lat;
  double _lon;
  bool _active;


  //ReminderData(this._id);
  ReminderData(this._id, this._text, this._creationDate, this._notificationDate, this._lat, this._lon, this._active);

  ReminderData.map(dynamic obj){
    this._id = obj['id'];
    this._text = obj['text'];
    this._creationDate = DateTime.parse(obj['creation']);
    if (obj['notification'] != null) this._notificationDate = DateTime.parse(obj['notification']);
    if (obj['lat'] != null) this._lat = double.parse(obj['lat']);
    if (obj['lon'] != null) this._lon = double.parse(obj['lon']);
    this._active = obj['active'];
  }

  String get id => _id;
  String get text => _text;
  DateTime get creationDate => _creationDate;
  DateTime get notificationDate => _notificationDate;
  double get lat => _lat;
  double get lon => _lon;
  bool get active => _active;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['text'] = _text;
    map['creation'] = _creationDate;
    if (_notificationDate != null) map['notification'] = _notificationDate;
    if (_lat != null) map['lat'] = _lat;
    if (_lon != null) map['lon'] = _lon;
    map['active'] = _active;
    return map;
  }

  ReminderData.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._text = map['text'];
    this._creationDate = map['creation'];
    if (map.containsKey('notification')) this._notificationDate = map['notification'];
    if (map.containsKey('lat')) this._lat = map['lat'];
    if (map.containsKey('lon')) this._lon = map['lon'];
    this._active = map['active'];
  }


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