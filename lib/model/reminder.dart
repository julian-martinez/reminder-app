import 'package:firebase_database/firebase_database.dart';

class ReminderData{

  String _id;
  String _text;
  DateTime _creationDate;
  DateTime _notificationDate;
  double _lat;
  double _lon;
  bool _active;

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

  ReminderData.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._text = snapshot.value['text'];
    this._creationDate = DateTime.parse(snapshot.value['creation']);
    if (snapshot.value['notification'] != null) this._notificationDate = DateTime.parse(snapshot.value['notification']);
    if (snapshot.value['lat'] != null) this._lat = double.parse(snapshot.value['lat']);
    if (snapshot.value['lon'] != null) this._lon = double.parse(snapshot.value['lon']);
    this._active = snapshot.value['active'];
  }

  String get id => _id;
  String get text => _text;
  DateTime get creationDate => _creationDate;
  DateTime get notificationDate => _notificationDate;
  double get lat => _lat;
  double get lon => _lon;
  bool get active => _active;

  bool get hasLatLon => _lat != null && _lon != null;
}