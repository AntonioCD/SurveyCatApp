// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:surveycat_app/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SurveyCat App',
      home: LoginScreen(),
    );
  }
}
