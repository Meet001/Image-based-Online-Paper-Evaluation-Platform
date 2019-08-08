import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class login extends StatelessWidget{

  const login({
    Key key,
    @required this.onSubmit,
  }) : super(key:key);

  final VoidCallback onSubmit;
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();

  String get username => _user.text;
  String get password => _password.text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('Here at Login page');
    return new Column(
      children: <Widget>[
        new TextField(controller:  _user, decoration: new InputDecoration(hintText:'User ID' ),),
        new TextField(controller:  _password, decoration: new InputDecoration(hintText:'Password'), obscureText: true,),
        new RaisedButton(child: new Text('Submit'), onPressed: onSubmit)
      ],
    );
  }
}