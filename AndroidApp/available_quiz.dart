import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/quiz_details.dart';
import 'package:student_app_updated/ques_upload.dart';

class parent_available extends StatefulWidget{

  final String id;
  final String course_id;

  parent_available({Key key, @required this.id, @required this.course_id}) : super(key: key);

  @override
  available createState() => new available(id, course_id);
}

class available  extends State<parent_available>{

  List availableData = new List();

  String id;
  String course_id;
  String loadingText = 'Loading';

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  available(String t, String cid){
    this.id = t;
    this.course_id = cid;
  }


  void showAvailable() {


    Session mySession = new Session();

    String myURL = prefix+"StudentAvailableQuiz?course_id="+course_id;
    print('done showAvailable');
    mySession.post(myURL, {}).then((String inString) {

      print(inString);

      if (inString == '{\"data\":[],\"status\":true}') {
        loadingText = 'No quizzes available';
        print('ans : ' + loadingText);
        setState(() {
          _current = false;
        });
      }
      else {

        print("setting available quiz");
        Map myArr = json.decode(inString);
        print(myArr['data']);
        availableData = myArr['data'];
        setState(() {
          _current = true;
        });

        print("QWEQWE");
      }
    });
  }



  Widget _myListView() {

    if(!_current && loadingText == 'No quizzes available'){
      return new Center(child: Text(loadingText));
    }
    else if (!_current && loadingText != 'No quizzes available') {
      showAvailable();
      return new Center(child: Text(loadingText));
    }

    else{
      return new ListView.builder(
          itemCount: availableData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text('Quiz no. : '+ availableData[i]['exam_name']),
              subtitle: Text('Maximum marks : '+availableData[i]['total_marks'].toString()),
              trailing: Text('Submission window : \n'
                  + availableData[i]['start_time'].toString()
                  + ' to '
                  + availableData[i]['upload_end_time'].toString()),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_quesup(
                          id: id, course_id: course_id, quiz_id: availableData[i]['exam_id'].toString(),
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
      print('done showAvailable');

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
            title: new Text('Available Quizzes'),
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