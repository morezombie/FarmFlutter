import 'package:flutter/material.dart';
import 'farmModel.dart';
import 'calcPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Have fun, farmer',
      home: Calculator(),
    );
  }
}
