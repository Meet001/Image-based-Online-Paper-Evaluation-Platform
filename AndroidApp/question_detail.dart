import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/grading_details.dart';

class parent_ques extends StatefulWidget{

  final String id;
  final String course_id;
  final String quiz_id;
  final String ques_id;
  final String ques_name;

  parent_ques({Key key, @required this.id, @required this.course_id,
    @required this.quiz_id, @required this.ques_id, @required this.ques_name}) :
        super(key: key);

  @override
  ques createState() => new ques(id, course_id, quiz_id, ques_id, ques_name);
}

class ques extends State<parent_ques>{

  List quesData = new List();

  File imgFile;
  String imgString;
  List <int> imgList;

  String id;
  String course_id;
  String quiz_id;
  String ques_id;
  String ques_name;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  ques(String t, String cid, String qid, String ques_id, String ques_name){
    this.id = t;
    this.course_id = cid;
    this.quiz_id = qid;
    this.ques_id = ques_id;
    this.ques_name = ques_name;
  }

  void showques() {

    String ans;

    Session mySession = new Session();


    String myURL = prefix+"QuesDetails?exam_id="+quiz_id+"&question_id="+ques_id;
    print('done showques');
    mySession.post(myURL, {}).then((String inString) {

      if (inString == '{\"data\":[],\"status\":true}') {
        ans = 'No Information available';
        print('ans : ' + ans);
      }
      else {
          print(inString);
        print("setting ques details screen");
        print(ques_name);

        Map myArr = json.decode(inString);
        print(myArr['data']);
        quesData = myArr['data'];
        print(quesData[1]['image'].toString().length);
        setState(() {
          _current = true;
        });

        print("QWEQWE");
      }
    });
  }


  Widget _myQuesWidget() {

    if (!_current) {
      showques();
      return new Center(child: Text('Loading'));
    }

    else{
      return new Center(
          child: new Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          new Text(
            'Question no. : '+ quesData[0]['question_name'],
            style: new TextStyle(
              fontSize: 20.0,
              ),
          ),
          new Text(
            'Marks awarded : '+ quesData[0]['marks'],
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          new Text(
            'Maximum marks : '+ quesData[0]['total_marks'],
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),

          new RaisedButton(child: new Text('Grading details'),

              onPressed: () {

                print(quesData[0]['quiz_id']);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_grading(
                          id: id,
                          course_id: course_id,
                          quiz_id: quesData[0]['quiz_id'].toString(),
                          ques_id: quesData[0]['question_id'].toString(),
                          ques_name: quesData[0]['question_name'],
                        )));
              },
          ),
        ],

      )
    );
    }
  }

  @override
  Widget build(BuildContext context){

    void _goHome(){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
              parent_home(
                  id: id
              )));
    }

    void _logout(){
      print('logout from home screen');

      Session exitSession = new Session();

      String myURL = prefix+"LogoutServlet";
      print('done showques');

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

        title: course_id,

        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue[800],
          accentColor: Colors.blue[600],
        ),

        home: new Scaffold(
          appBar: new AppBar(
            title: new Text(ques_name+' Details'),
            actions: <Widget>[

              new IconButton(icon: new Icon(Icons.arrow_back),
                  onPressed: (){Navigator.pop(context,true);}),

              new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),

              new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();}),
            ],
          ),
          body: _myQuesWidget(),
          resizeToAvoidBottomPadding: false,
        )
    );
  }
}