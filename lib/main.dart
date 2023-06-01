import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_page.dart';
import 'style.dart';
import 'dart:math';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = 2;
    int maxPlayers = 8;
    int base = 40;
    Wakelock.enable();
    if(Platform.isAndroid || Platform.isIOS){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    Map playersInfo = {
      "colors":List.generate(maxPlayers, (index) => colorsList[index]),
      "commander":List.generate(maxPlayers, (index) => List.generate(maxPlayers, (subIndex) => 0)),
      "life":List.generate(maxPlayers, (index) => base),
      "rolling":List.generate(maxPlayers, (index) => false),
      "diceValues":List.generate(maxPlayers, (index) => 0),
      "activeTemp":List.generate(maxPlayers, (index) => false),

      "initiative":List.generate(maxPlayers, (index) => false),
      "ascended":List.generate(maxPlayers, (index) => false),
      "monarch":List.generate(maxPlayers, (index) => false),

      'infect':List.generate(maxPlayers, (index) => 0),
      'energy':List.generate(maxPlayers, (index) => 0),
      'treasure':List.generate(maxPlayers, (index) => 0),
      'experience':List.generate(maxPlayers, (index) => 0),
      'cmd. tax':List.generate(maxPlayers, (index) => 0),

      "starter":Random().nextInt(numberOfPlayers)+1,
      "numberOfPlayers":maxPlayers,
      "base":base,
      "playing":true,
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LifeKeeper",
      home: MainPage(
        numberOfPlayers: numberOfPlayers,
        playersInfo: playersInfo,
        base: base,
        isPlaying: true,
      ),
    );
  }
}
