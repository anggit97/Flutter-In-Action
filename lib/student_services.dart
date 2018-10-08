import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'student_model.dart';


//Optional
Future<String> _loadStudentAsset() async{
  return await rootBundle.loadString('assets/student.json');
}

Future loadStudent() async{
  String jsonString = await _loadStudentAsset();
  final jsonResponse = jsonDecode(jsonString);
  Student student = new Student.fromJson(jsonResponse);
  print(student.name);
}