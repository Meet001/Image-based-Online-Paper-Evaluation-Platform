/*
 * Based on an answer by Richard Heap on stackoverflow.
 * Original link:
 * https://stackoverflow.com/questions/50299253/flutter-http-maintain-php-session
 */


import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';

class Session {
  static final Session _session = new Session._internal();
  factory Session(){
    return _session;
  }
  Session._internal();

  Map<String, String> headers = {};

  Future<String> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<Response<String>> diopost(String url,FormData mydata) async {
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-from-urencoded");
    Response<String> response = await dio.request(url,data: mydata,options: new Options(headers:headers));
    print(response);
    return response;
  }

  String upload(String url,  List<int> imageBytes , String myfile){
    var myURL = Uri.parse(url);
    var request = http.MultipartRequest("POST", myURL);
    print('done showcam');
    print(myURL);
    request.headers['cookie'] = headers['cookie'];
    print(imageBytes);
    request.files.add(
         http.MultipartFile.fromBytes('file', imageBytes,filename: myfile));
    request.send().then((response) {
      print(response.statusCode);
    });
    return "1";
  }



  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}