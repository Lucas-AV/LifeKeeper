library universal;


import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

int maxNumberOfPlayers = 6;

int currentRound = 0;

int lifepadIndexTurn = 0;

Map<String,IconData> typesOfCounters = {
  "Commander Tax":MdiIcons.shieldHalfFull,
  "Experience":MdiIcons.ticketPercent, 
  "Infect":MdiIcons.biohazard,
  "Energy":Icons.bolt_rounded,
  "Storm":MdiIcons.weatherLightning,
  "Life":Icons.favorite_rounded,
};

List<LifepadModel> lifepadModels = [
  LifepadModel(index: 0, life: 40, color: Colors.red),
  LifepadModel(index: 1, life: 40, color: Colors.blue),
  LifepadModel(index: 2, life: 40, color: Colors.green),
  LifepadModel(index: 3, life: 40, color: Colors.orange),
  LifepadModel(index: 4, life: 40, color: Colors.purple),
  LifepadModel(index: 5, life: 40, color: Colors.teal),
];
