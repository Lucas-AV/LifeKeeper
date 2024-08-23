
import 'package:flutter/material.dart';

class LifepadModel {
  Color fontColor = Colors.white;
  bool isDead = false;
  Color color;
  int index;
  int life;

  String currentTypeOfCounter = "Life";

  Map<String, bool> conditions = {
    "initiative": false,
    "ascended": false, // When the player has ascended (have 10 permanents on the battlefield)
    "corrupted": false, // When the number of infect counters is bigger or equal than 3
    "monarch": false,
  };

  Map<String, int> counters = {
    "Commander Tax":0,
    "Experience":0, 
    "Energy":0,
    "Infect":0,
    "Storm":0,
    "Life":0,
  };

  LifepadModel({required this.index, required this.life, required this.color});
}
