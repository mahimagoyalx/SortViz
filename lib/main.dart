import 'package:flutter/material.dart';
import 'package:sortviz/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Visualiser',
      theme: ThemeData(
        fontFamily: 'Lato',
        primaryColor: Colors.grey.shade800,
        bottomAppBarColor: Colors.grey.shade800,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
