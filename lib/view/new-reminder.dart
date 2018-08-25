import 'package:flutter/material.dart';
import '../i18n.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:fluttery/framing.dart';

class Reminder extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {

  bool _activeNotification;
  bool _activeLocation;

  double _lat;
  double _lon;
  DateTime _notificationDate;
  TimeOfDay _notificationTime;

  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = new TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);


  @override
  void initState() {
    _activeNotification = false;
    _activeLocation = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back), 
            onPressed: (){}
        ),
        title: new Text('Nuevo recordatorio'),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new TextFormField(
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 255,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe tu recordatorio',
                    )
                  )
              ),
            ),
          activateNotification(_activeNotification),
          activateLocation(_activeLocation),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: new FloatingActionButton(
          onPressed: (){},
        child: const Icon(Icons.done),
      ),
      bottomNavigationBar: new BottomAppBar(
        hasNotch: true,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
            new Padding(
              padding: const EdgeInsets.only(left:4.0, right: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.add_alert),
                  color: _activeNotification ? Colors.lightBlue : Colors.black,
                  onPressed: (){
                    setState(() {
                      _activeNotification = !_activeNotification;
                      //_notification = _activeNotification ? DateTime.now().add(new Duration(minutes: 2)) : null;
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
              child: new _DateTimePicker(
                labelText: 'Notificar en',
                selectedDate: _toDate,
                selectedTime: _toTime,
                selectDate: (DateTime date){
                  setState(() {
                    _notificationDate = date;
                  });
                },
                selectTime: (TimeOfDay time){
                  setState(() {
                    _notificationTime = time;
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
                  child: new Text('Localización guardada', style: TextStyle(fontSize: 18.0),)
              )
          )
        ],
      );
    } else {
      return new Container();
    }
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 2,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () { _selectTime(context); },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}
