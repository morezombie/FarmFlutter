import 'farmModel.dart';
import 'calcPage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  // TRICKY ugly impl
  HttpOverrides.global = new DevHttpOverrides();
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

// TRICKY ugly impl
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}