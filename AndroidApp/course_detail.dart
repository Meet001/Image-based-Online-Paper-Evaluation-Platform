import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/quiz_details.dart';
import 'package:student_app_updated/available_quiz.dart';


class parent_course extends StatefulWidget{

  final String id;
  final String course_id;

  parent_course({Key key, @required this.id, @required this.course_id}) : super(key: key);

  @override
  course createState() => new course(id, course_id);
}

class course extends State<parent_course>{

  List courseData = new List();

  String id;
  String course_id;

  bool noData = false;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  course(String t, String cid){
    this.id = t;
    this.course_id = cid;
  }

  void showcourse() {

    String ans;

    Session mySession = new Session();

    String myURL = prefix+"StudentCourseQuizzes?course_id="+course_id;
    print('done showcourse');
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

        print("setting course screen");
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


  Widget _myListView() {

    if (!_current) {
      if(noData){
        return new Center(child: Text('No quizzes to show'));
      }
      else{
      showcourse();
      return new Center(child: Text('Loading'));
      }
    }

    else{
      return new ListView.builder(
          itemCount: courseData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text('Quiz name. : '+ courseData[i]['exam_name']),
              subtitle: Text('Maximum Marks : '+courseData[i]['total_marks'].toString()),
              trailing: Text('Weightage :' + courseData[i]['weightage'].toString()),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_quiz(
                            id: id, course_id: course_id, quiz_id: courseData[i]['exam_id'].toString(),
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
      print('done showcourse');

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
          accentColor: Colors.blue[800],
        ),

        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Course Details'),
            actions: <Widget>[

              new IconButton(icon: new Icon(Icons.arrow_back),
                  onPressed: (){Navigator.pop(context,true);}),

              new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),

              new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();}),
            ],
          ),
          body: _myListView(),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: Colors.blue,
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_available(
                          id: id, course_id: course_id,
                        )));
              },
          ),
          resizeToAvoidBottomPadding: false,
        )
    );
  }
}