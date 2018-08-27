import 'package:flutter/material.dart';
import '../i18n.dart';
import 'reminder-list.dart';

import 'package:fluttery/framing.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Flexible(child: new Container(), flex: 1),
          new TextFormFieldCentered(
              hintText: I18n.of(context).getValueOf(Strings.FORM_EMAIL), prefixIcon: Icons.person),
          new Padding(padding: const EdgeInsets.only(top: 4.0, bottom: 4.0)),
          new TextFormFieldCentered(
              hintText: I18n.of(context).getValueOf(Strings.FORM_PASSWORD), prefixIcon: Icons.lock),
          new Padding(padding: const EdgeInsets.only(top: 12.0, bottom: 12.0)),
          new Row(
            children: <Widget>[
              new Flexible(
                child: new Container(),
                flex: 1,
              ),
              new Expanded(
                child: new RaisedButton(
                    child: new Text(I18n.of(context).getValueOf(Strings.BTN_LOGIN)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ReminderList()
                      ));
                    }
                    ),
                flex: 6,
              ),
              new Flexible(
                child: new Container(),
                flex: 1,
              ),
            ],
          ),
          new Flexible(child: new Container(), flex: 1),
        ],
      ),
    );
  }
}

class TextFormFieldCentered extends StatefulWidget {
  TextFormFieldCentered(
      {Key key,
      this.keyboardType,
      this.labelText,
      this.hintText,
      this.prefixIcon})
      : super(key: key);

  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;

  @override
  _TextFormFieldCenteredState createState() => _TextFormFieldCenteredState();
}

class _TextFormFieldCenteredState extends State<TextFormFieldCentered> {
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Flexible(
          child: new Container(),
          flex: 1,
        ),
        new Flexible(
          flex: 6,
          child: new Container(
            color: Colors.lightBlueAccent,
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: new IconHolder(widget.prefixIcon),
                ),
                new Expanded(
                  child: new Container(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    color: Colors.white,
                    child: new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                        labelText: widget.labelText,
                        hintText: widget.hintText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        new Flexible(
          child: new Container(),
          flex: 1,
        ),
      ],
    );
  }
}

class IconHolder extends StatelessWidget {
  IconHolder(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Opacity(
        opacity: 1.0,
        child: new Container(
          child: new Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
