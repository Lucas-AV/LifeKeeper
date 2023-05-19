import 'package:flutter/material.dart';
import 'main_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = 2;
    int base = 40;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(
        numberOfPlayers: numberOfPlayers,
        base: base,
      ),
    );
  }
}