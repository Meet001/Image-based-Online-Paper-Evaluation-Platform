import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/course_detail.dart';


class parent_home extends StatefulWidget{

  final String id;

  parent_home({Key key, @required this.id}) : super(key: key);

  @override
    homes createState() => new homes(id);
}

class homes extends State<parent_home>{

  List courseData = new List();

  String id;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  homes(String t){
    this.id = t;
  }


  void showhome() {

    String ans;

      Session mySession = new Session();

      String myURL = prefix+"StudentHome";


      print('done showhome');
      mySession.post(myURL, {}).then((String inString) {

        if (inString == '{\"data\":[],\"status\":true}') {
          ans = 'No Information available';
          print('ans : ' + ans);
        }
        else {


        print("setting home screen");
        print(inString);
          Map myArr = json.decode(inString);
          print(myArr['data']);
          courseData = myArr['data'];
          setState(() {
            _current = true;
          });

          print("QWEQWE");
        }
      });
  }


  Widget myListView() {

    if (!_current) {
      showhome();
      return new Center(child: Text('Loading'));
    }

    else{
      return new ListView.builder(
          itemCount: courseData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text('Course ID : '+ courseData[i]['course_id']),
              subtitle: Text('Course name : '+courseData[i]['title'].toString()),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_course(
                            id: id, course_id: courseData[i]['course_id']
                        )));
              },
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context){

    void _goHome(){
      setState((){
      _current = false;
    });}

    void _logout(){
      print('logout from home screen');

      Session exitSession = new Session();

      String myURL = prefix+"LogoutServlet";
      print('done showhome');

      exitSession.post(myURL, {}).then((String exitString) {
        print("Here -> ");
        print(exitString);
        print(exitString == "{\"status\":true}");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                MyHomePage(
                )));

      });
    }

    return new MaterialApp( //

    title: 'Conversation Details',

        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue[800],
          accentColor: Colors.blue[800],
        ),

    home: new Scaffold(
      appBar: new AppBar(
          title: new Text('Homepage'),
          actions: <Widget>[

            new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),

            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();}),
            ],
          ),
      body: myListView(),
    resizeToAvoidBottomPadding: false,
      )
    );
  }
}