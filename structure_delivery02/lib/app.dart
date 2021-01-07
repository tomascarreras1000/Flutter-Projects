import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/character_screen.dart';
import 'screens/world_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery 03',
      home: WorldScreen(),
    );
  }
}
