import 'package:flutter/material.dart';
import 'package:student_app_updated/myMain.dart';
import 'package:student_app_updated/session.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:student_app_updated/config.dart';
import 'package:student_app_updated/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img2;

class parent_cam extends StatefulWidget{

  final String id;
  final String course_id;
  final String quiz_id;
  final String ques_id;

  parent_cam({Key key, @required this.id, @required this.course_id,
    @required this.quiz_id, @required this.ques_id}) :
        super(key: key);

  @override
  cam createState() => new cam(id, course_id, quiz_id, ques_id);
}

class cam extends State<parent_cam>{

  List camData = new List();

  File myImage;
  String base64Image;
  List<int> imageBytes;

  String id;
  String course_id;
  String quiz_id;
  String ques_id;

  int counter = 0;

  bool _current = false;

  static Conn conn = new Conn();

  String prefix = conn.getPrefix();

  cam(String t, String cid, String qid, String ques_id){
    this.id = t;
    this.course_id = cid;
    this.quiz_id = qid;
    this.ques_id = ques_id;
  }


  Widget _myQuesWidget() {

    if(!_current){
        return new Center(child: Text("Waiting for an image."));
    }

    else{

      if(myImage != null){

        return new Container(
          child: new Center(
            child: myImage == null
                ? new Text("Images uploaded so far:"+counter.toString())
                : new Image.file(myImage),
          ),
        );
      }

      return new Center(
          child: new Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              new Text(
                'Image uploaded.',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],

          )
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
      print('done showcam');

      exitSession.post(myURL, {}).then((String exitString) {
        print("Here -> ");
        print(exitString);
        print(exitString == "{\"status\":true}");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                MyHomePage(
                  //id1: id, id2: camData[i]['uid']
                )));

      });
    }


    picker() async {
      print('Picker is called');
      File img = await ImagePicker.pickImage(source: ImageSource.camera);
      if (img != null) {
        myImage = img;

        imageBytes = myImage.readAsBytesSync();
        print(imageBytes.length);

        var decodedImg = Img2.decodeImage(imageBytes);

        var newImgFile = Img2.encodeJpg(decodedImg, quality: 50);

        base64Image = base64Encode(newImgFile);
        base64Image = Uri.encodeComponent(base64Image);

        print(base64Image.length);
        base64Image="data:image/jpeg;base64,"+base64Image;

        print('64 string is: ');
        print(base64Image);

        setState(() {
          _current = true;
        });
      }
    }

    dioUploader() async {
      Session mySessionUp = new Session();

      FormData formData = new FormData.from({
        "ques_id": ques_id,
        "SubmissionImg": base64Image
      });
     Response<String> response = await mySessionUp.diopost(prefix + "StudentImgUpload", formData);

     print("This is response");
     print(response.toString());

     setState(() {
       counter++;
       _current=true;
       myImage=null;

     });
      print(counter);
     //Navigator.pop(context,true);
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
            title: new Text('Image upload'),
            actions: <Widget>[

              new IconButton(icon: new Icon(Icons.arrow_back),
                  onPressed: (){Navigator.pop(context,true);}),

              new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),

              new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();}),
            ],
          ),
          body: _myQuesWidget(),

          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: new Icon(Icons.file_upload),
                onPressed: dioUploader,
              )),
              Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: picker,
                child: new Icon(Icons.camera_alt),)
              )
            ],
          ),
          resizeToAvoidBottomPadding: false,
        )
    );
  }
}