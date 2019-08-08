import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:student_app_updated/camera_link.dart';


class parent_quesup extends StatefulWidget{

  final String id;
  final String course_id;
  final String quiz_id;

  parent_quesup({Key key, @required this.id, @required this.course_id,
    @required this.quiz_id}) :
        super(key: key);

  @override
  quesup createState() => new quesup(id, course_id, quiz_id);
}

class quesup  extends State<parent_quesup>{

  List quesUpData = new List();

  String id;
  String course_id;
  String quiz_id;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  quesup(String t, String cid, String qid){
    this.id = t;
    this.course_id = cid;
    this.quiz_id = qid;
  }


  void showquesup() {

    print("50");
    print(quiz_id);

    String ans;

    Session mySession = new Session();

    String myURL = prefix+"StudentAvailableQues?exam_id="+quiz_id;
    print(myURL);
    print('done showquesup');
    mySession.post(myURL, {}).then((String inString) {

      if (inString == '{\"data\":[],\"status\":true}') {
        ans = 'No Information available';
        print('ans : ' + ans);
      }
      else {

        print(inString);
        print("setting ques upload screen");
        Map myArr = json.decode(inString);
        print(myArr['data']);
        quesUpData = myArr['data'];
        setState(() {
          _current = true;
        });

        print("ASDFGH");
      }
    });
    //  return ans;
  }

  Widget _myQuesWidget() {

    if (!_current) {
      showquesup();
      return new Center(child: Text('Loading'));
    }

    else{
      return new ListView.builder(
          itemCount: quesUpData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text('Question no. : '+ quesUpData[i]['question_name'].toString()),
              subtitle: Text('Marks: '+quesUpData[i]['total_marks'].toString()),
              onTap: () {
                print("Haayo");
                print(quesUpData[i]['question_id']);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        parent_cam(
                          id: id, course_id: course_id,
                          quiz_id: quesUpData[i]['quiz_id'].toString(),
                          ques_id: quesUpData[i]['question_id'].toString(),
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
      print('done showquesup');

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
            title: new Text('Available questions'),
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