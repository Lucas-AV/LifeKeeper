import 'dart:io';

import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = 6;
    int base = 40;
    // Wakelock.enable();
    if(Platform.isAndroid || Platform.isIOS){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LifeKeeper",
      home: MainPage(
        numberOfPlayers: numberOfPlayers,
        base: base,
      ),
    );
  }
}
