import 'farmModel.dart';
import 'calcPage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi, farmer!',
      home: Calculator(),
    );
  }
}