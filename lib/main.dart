import 'package:flutter/material.dart';
import 'package:sortviz/view/home.dart';

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
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.black,
          thumbColor: Color(0xFFEB1555),
          overlayColor: Color(0x29EB1555),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
