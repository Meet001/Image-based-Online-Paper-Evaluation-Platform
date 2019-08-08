import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';


class parent_grading extends StatefulWidget{

  final String id;
  final String course_id;
  final String quiz_id;
  final String ques_id;
  final String ques_name;

  parent_grading({Key key, @required this.id, @required this.course_id,
    @required this.quiz_id, @required this.ques_id, @required this.ques_name}) :
        super(key: key);

  @override
  grading createState() => new grading(id, course_id, quiz_id, ques_id, ques_name);
}

class grading extends State<parent_grading>{

  List gradingData = new List();

  String id;
  String course_id;
  String quiz_id;
  String ques_id;
  String ques_name;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  grading(String t, String cid, String qid, String ques_id, String ques_name){
    this.id = t;
    this.course_id = cid;
    this.quiz_id = qid;
    this.ques_id = ques_id;
    this.ques_name = ques_name;
  }

  void showgrading() {

    print("Start showgrading");

    String ans;

    Session mySession = new Session();
    print("62");
    print(prefix);
    print(quiz_id);
    print(ques_id);

    String myURL = prefix+"GradingDetails?exam_id="+quiz_id+"&question_id="+ques_id;
    print('done showgrading');
    mySession.post(myURL, {}).then((String inString) {

      if (inString == '{\"data\":[],\"status\":true}') {
        ans = 'No Information available';
        print('ans : ' + ans);
      }
      else {

        print("setting grading details screen");
        print(inString);
        Map myArr = json.decode(inString);
        print(myArr['data']);
        gradingData = myArr['data'];
        setState(() {
          _current = true;
        });

        print("QWEQWE");
      }
    });
  }





  Widget _myQuesWidget() {

    if (!_current) {
      showgrading();
      return new Center(child: Text('Loading'));
    }

    else{
      return new Center(
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Question no. : '+ gradingData[0]['question_name'],
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          new Text(
            'Marks awarded : '+ gradingData[0]['marks'].toString(),
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),

          new Text(
            'Total marks : '+ gradingData[0]['total_marks'].toString(),
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),

          new Text(
            'Evaluator\'s comments: '+ gradingData[0]['comment'],
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),

        ],
      ),
    );
    }
  }
//  }
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
      print('done showgrading');

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