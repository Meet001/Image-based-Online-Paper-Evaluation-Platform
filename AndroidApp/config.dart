
import 'dart:async';
import 'package:http/http.dart' as http;

class Conn {
  static final Conn _conn = new Conn._internal();
  factory Conn(){
    return _conn;
  } Conn._internal();

  String getPrefix() {
    return "http://10.196.27.144:8080/DBFinalProject/";
  }
}