import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/grading_details.dart';


class parent_quiz extends StatefulWidget{

  final String id;
  final String course_id;
  final String quiz_id;

  parent_quiz({Key key, @required this.id, @required this.course_id, @required this.quiz_id}) :
        super(key: key);

  @override
  quiz createState() => new quiz(id, course_id, quiz_id);
}

class quiz extends State<parent_quiz>{

  List quizData = new List();

  String id;
  String course_id;
  String quiz_id;

  bool _current = false;
  bool noData = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  quiz(String t, String cid, String qid){
    this.id = t;
    this.course_id = cid;
    this.quiz_id = qid;
  }


  void showquiz() {

    String ans;

    Session mySession = new Session();

    String myURL = prefix+"QuizDetails?exam_id="+quiz_id;
    print('done showquiz');
    mySession.post(myURL, {}).then((String inString) {

      if (inString == '{\"data\":[],\"status\":true}') {
        ans = 'No Information available';
        print('ans : ' + ans);
        setState(() {
          noData = true;
        });

      }
      else {
        print(inString);
        print("setting quiz screen");
        Map myArr = json.decode(inString);
        print(myArr['data']);
        quizData = myArr['data'];
        setState(() {
          _current = true;
        });

        print("QWEQWE");
      }
    });
  }


  Widget _myListView() {

    if (!_current) {
      if(noData){
        return new Center(child: Text('No questions to show'));
      }

      else{
      showquiz();
      return new Center(child: Text('Loading'));
      }
    }

    else{
      return new ListView.builder(
          itemCount: quizData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text('Question no. : '+ quizData[i]['question_name']),
              subtitle: Text('Marks given : '+quizData[i]['marks'].toString()+'/'+quizData[i]['total_marks'].toString()),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_grading(
                          id: id,
                          course_id: course_id,
                          quiz_id: quiz_id,
                          ques_id: quizData[i]['question_id'].toString(),
                          ques_name: quizData[i]['question_name'],
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
      print('done showquiz');

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
            title: new Text('Quiz Details'),
            actions: <Widget>[

              new IconButton(icon: new Icon(Icons.arrow_back),
                  onPressed: (){Navigator.pop(context,true);}),

              new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),

              new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();}),
            ],
          ),
          body: _myListView(),
          resizeToAvoidBottomPadding: false,
        )
    );
  }
}