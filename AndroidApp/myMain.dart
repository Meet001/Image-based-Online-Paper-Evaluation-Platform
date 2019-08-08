import 'package:flutter/material.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/login.dart';
import 'package:student_app_updated/session.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:student_app_updated/config.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue[800],
        accentColor: Colors.blue[600],
      ),
      home: new Scaffold(body: new MyHomePage(title:'Student App' )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class ID {
  final String name;
  ID(this.name);
}

class _MyHomePageState extends State<MyHomePage> {



  String _title = "Enter login details";
  Widget _screen;
  login _login;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  bool _authenticated;
  String _myUsername;


  _MyHomePageState(){
    _login = new login(onSubmit: (){onSubmit();});

    _screen = _login;
    _authenticated = false;
  }

  void onSubmit(){
    print('Login with '+_login.username+' '+_login.password);
    if(_login.username==Null||_login.username.isEmpty||_login.password==Null||_login.password.isEmpty) {
      onSubmit_null();
      print("Stuck with Null.");
    }

    else {
      print("Not null");
      Session mySession = new Session();

      Map myMap =
      {
        'userid': _login.username,
        'password': _login.password,
      };
      String myURL = prefix+"LoginStudent";

      print(myURL);

      mySession.post(myURL, myMap).then((String inString) {
        print("Starts here: " + inString + " - Ends here");

        if (inString == '{\"status\":true}') {
          //_setAuthenticated(true);
          _authenticated = true;
          print('Now we here 1010');
          _myUsername = _login.username;

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => parent_home(
                  id: _myUsername
              )));

          print('Now we here 0000');
        }
        else{
          print('Now failing');


          final snackBar = SnackBar(content: Text('Authentication Failed.'));

          Scaffold.of(context).showSnackBar(snackBar);
        }
      });
    }

  }

  void onSubmit_null(){
    final snackBar = SnackBar(content: Text('Field cannot be empty.'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue[800],
          accentColor: Colors.blue[600],
        ),

        title: "Login page",

        home: new Scaffold(
          appBar: new AppBar(

            title: new Text(_title),
            actions: <Widget>[
            ],
          ),
          body: _screen,
          resizeToAvoidBottomPadding: false,
        )
    );
  }
}