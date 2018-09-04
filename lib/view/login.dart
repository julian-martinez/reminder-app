import 'package:flutter/material.dart';
import '../i18n.dart';
import 'reminder_list.dart';
import 'dart:async';
import '../dependency_injection.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttery/framing.dart';

final String EMAIL_NOT_REGISTERED = "There is no user record corresponding to this identifier. The user may have been deleted.";
final String EMAIL_ALREADY_REGISTERE8 = "The email address is already in use by another account.";
final String INCORRECT_PASSWORD = "The password is invalid or the user does not have a password.";


Future<FirebaseUser> _handleSignIn(String email, String password) async {
  FirebaseUser user = await new Injector().auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return user;
}

Future<FirebaseUser> _handleRegister(String email, String password) async {
  FirebaseUser user = await new Injector().auth.createUserWithEmailAndPassword(
      email: email,
      password: password
  );
  return user;
}

void _handleRecovery(String email) {
  new Injector().auth.sendPasswordResetEmail(
      email: email
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();

  final emailController = new TextEditingController();
  final passController = new TextEditingController();
  final rePassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            new Flexible(child: new Container(), flex: 1),
            new TextFormFieldCentered(
              controller: emailController,
              hintText: I18n.of(context).getValueOf(Strings.FORM_EMAIL),
              prefixIcon: Icons.person,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => !_isValidEmail(value) ? I18n.of(context).getValueOf(Strings.VAL_EMAIL) : null,
            ),
            new Padding(padding: const EdgeInsets.only(top: 4.0, bottom: 4.0)),
            new TextFormFieldCentered(
              controller: passController,
              hintText: I18n.of(context).getValueOf(Strings.FORM_PASSWORD),
              prefixIcon: Icons.lock,
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (value) => value.length < 6 ? I18n.of(context).getValueOf(Strings.VAL_PASS) : null,
            ),
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
                        String _email = emailController.text.toString();
                        String _pass = passController.text.toString();
                        if (_formKey.currentState.validate()){
                          _signInFlow(context, _email, _pass);
                        } else {
                          _showMessageDialog(I18n.of(context).getValueOf(Strings.ERROR), I18n.of(context).getValueOf(Strings.ERROR_LOGIN));
                        }
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
      )
    );
  }

  bool _isValidEmail(String value) {
    final Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }

  void _signInFlow(BuildContext context, String email, String password){
    _handleSignIn(email, password)
        .then((FirebaseUser user) {
          if (user.isEmailVerified) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ReminderList(user: user,)
            ));
          } else {
            _showVerifyAccountDialog(context, user);
          }
        })
        .catchError((e) {
          if (e.toString().contains(INCORRECT_PASSWORD)){
            _showLostPasswordDialog(context, email);
          } else if (e.toString().contains(EMAIL_NOT_REGISTERED)){
            _showRegisterDialog(context, email, password);
          } else {
            _showMessageDialog(I18n.of(context).getValueOf(Strings.ERROR), I18n.of(context).getValueOf(Strings.ERROR_LOGIN));
          }
        });
  }

  void _showVerifyAccountDialog(BuildContext context, FirebaseUser user){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text(I18n.of(context).getValueOf(Strings.VERIFY_TITLE)),
          content: new Text(I18n.of(context).getValueOf(Strings.VERIFY_MESSAGE)),
          actions: <Widget>[
            new FlatButton(
              onPressed: (){
                Navigator.pop(context);
                user.sendEmailVerification();
              },
              child: new Text(I18n.of(context).getValueOf(Strings.BTN_RESEND_MAIL).toUpperCase()),
            ),
            new FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: new Text(I18n.of(context).getValueOf(Strings.BTN_OK).toUpperCase()),
            ),
          ],
        );
      }
    );
  }

  void _showLostPasswordDialog(BuildContext context, String email){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text(I18n.of(context).getValueOf(Strings.DLGT_LOST_PASS)),
          content: new Text(I18n.of(context).getValueOf(Strings.DLGM_LOST_PASS)),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text(I18n.of(context).getValueOf(Strings.BTN_NO).toUpperCase()),
            ),
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _handleRecovery(email);
                  _showMessageDialog(I18n.of(context).getValueOf(Strings.DLGT_SEND_EMAIL), I18n.of(context).getValueOf(Strings.DLGM_SEND_EMAIL));
                },
                child: new Text(I18n.of(context).getValueOf(Strings.BTN_YES).toUpperCase()),
            )
          ],

        );
      }
    );
  }

  void _showRegisterDialog(BuildContext context, String email, String password){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new Form(
          key: _secondFormKey,
            child: AlertDialog(
              title: new Text(I18n.of(context).getValueOf(Strings.DLGT_COMPLETE_REGISTER)),
              content: new Container(
                height: 60.0,
                      width: 360.0,
                      child: new TextFormFieldCentered(
                        dialog: true,
                        controller: rePassController,
                        hintText: I18n.of(context).getValueOf(Strings.FORM_REPASSWORD),
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) => value != password ? I18n.of(context).getValueOf(Strings.VAL_REPASS) : null,
                        //onSaved: (value) => _pass = value,
                      ),

              ),

              actions: <Widget>[
                new FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: new Text(I18n.of(context).getValueOf(Strings.BTN_CANCEL).toUpperCase()),
                ),
                new FlatButton(
                  onPressed: (){
                    if(_secondFormKey.currentState.validate()){
                      _handleRegister(email, password)
                          .then((FirebaseUser user){
                        user.sendEmailVerification();
                        Navigator.pop(context);
                        _showVerifyAccountDialog(context, user);
                      })
                          .catchError(() {
                        Navigator.pop(context);
                        _showMessageDialog(I18n.of(context).getValueOf(Strings.ERROR), I18n.of(context).getValueOf(Strings.ERROR_REGISTER));
                      });
                    }
                  },
                  child: new Text(I18n.of(context).getValueOf(Strings.BTN_CONTINUE).toUpperCase()),
                )
              ],
            )
        );
      }
    );
  }

  void _showMessageDialog(String title, String message){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text(I18n.of(context).getValueOf(Strings.BTN_OK).toUpperCase())
            )
          ],
        );
      }
    );
  }
}

class TextFormFieldCentered extends StatefulWidget {
  TextFormFieldCentered(
      {Key key,
      this.controller,
      this.keyboardType,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      this.validator,
      this.obscureText,
      this.onSaved,
      this.dialog
      })
      : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  FormFieldValidator<String> validator;
  final bool obscureText;
  FormFieldSetter<String> onSaved;
  final bool dialog;

  @override
  _TextFormFieldCenteredState createState() => _TextFormFieldCenteredState();
}

class _TextFormFieldCenteredState extends State<TextFormFieldCentered> {
  @override
  Widget build(BuildContext context) {
    bool _obscureText = widget.obscureText != null ? widget.obscureText : false;
    bool _dialog = widget.dialog != null ? widget.dialog : false;
    return new Container(
      color: _dialog ? Colors.white : Colors.lightBlueAccent,
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new Container(),
            flex: _dialog ? null : 1,
          ),
          new Flexible(
              flex: 6,
              child: new Container(
                color: _dialog ? Colors.white : Colors.lightBlueAccent,
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: new IconHolder(widget.prefixIcon, _dialog),
                    ),
                    new Expanded(
                      child: new Container(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        color: _dialog ? Colors.white : Colors.lightBlueAccent,
                        child: new TextFormField(
                          controller: widget.controller,
                          keyboardType: widget.keyboardType,
                          obscureText: _obscureText,
                          validator: widget.validator,
                          onSaved: widget.onSaved,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 16.0),
                              labelText: widget.labelText,
                              hintText: widget.hintText,
                              hintStyle: new TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          new Flexible(
            child: new Container(),
            flex: _dialog ? null : 1,
          ),
        ],
      )
    );
    //return ;
  }
}

class IconHolder extends StatelessWidget {
  IconHolder(this.icon, this.dialog);

  final IconData icon;
  final bool dialog;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Opacity(
        opacity: 1.0,
        child: new Container(
          child: new Icon(
            icon,
            color: dialog ? Colors.lightBlueAccent : Colors.white,
          ),
        ),
      ),
    );
  }
}