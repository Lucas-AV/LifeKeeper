import 'package:flutter/material.dart';
import 'lifepad.dart';

List<Color> colorsList = [
  Colors.transparent,
  const Color(0xffB22222),
  const Color(0xff1E8449),
  const Color(0xff355691),
  const Color(0xff101214),
  Colors.deepOrange,
  Colors.pink,
  Colors.teal,
  const Color(0xff429AB7),
  Colors.redAccent,

  Colors.blueGrey,
  const Color(0xff14453D),
  Colors.black,

  const Color(0xff990099),
  const Color(0xff484743),
  const Color(0xff20A39E),
  const Color(0xff0B3948),
  Colors.deepPurple,
  Colors.white,
];

Map<String, Color> colorMap = {
  "NULL":Colors.transparent,
  "Apple Green - Matte Sleeves": const Color.fromRGBO(0,158,75,1),
  "Ruby - Matte Sleeves": const Color.fromRGBO(165,25,31,1),
  "Black - Matte Sleeves": const Color.fromRGBO(25,21,22,1),
  "Sapphire - Matte Sleeves": const Color.fromRGBO(11,135,192,1),
  "Glacier - Matte Dual Sleeves": const Color.fromRGBO(0,158,170,1),
  "Magenta - Matte Sleeves": const Color.fromRGBO(175,27,86,1),
  "Orange - Matte Sleeves": const Color.fromRGBO(248,154,0,1),
  "Brown - Classic Sleeves": const Color.fromRGBO(80,37,16,1),
  "Copper - Classic Sleeves": const Color.fromRGBO(146,73,39,1),
  "Copper - Matte Sleeves": const Color.fromRGBO(176,87,59,1),
  "Crimson - Matte Sleeves": const Color.fromRGBO(190,9,23,1),
  "Crypt - Matte Dual Sleeves": const Color.fromRGBO(132,126,115,1),
  "Ember - Dual Matte Sleeves": const Color.fromRGBO(215,74,40,1),
  "Emerald - Matte Sleeves": const Color.fromRGBO(4,85,40,1),
  "Eucalyptus - Matte Dual Sleeves": const Color.fromRGBO(167,213,189,1),
  "Forest Green - Matte Sleeves": const Color.fromRGBO(65,94,65,1),
  "Gold - Classic Sleeves": const Color.fromRGBO(148,98,38,1),
  "Gold - Matte Sleeves": const Color.fromRGBO(166,97,17,1),
  "Green - Classic Sleeves": const Color.fromRGBO(0,112,88,1),
  "Green - Matte Sleeves": const Color.fromRGBO(0,89,53,1),
  "Ivory - Matte Sleeves": const Color.fromRGBO(228,220,193,1),
  "Jet - Matte Sleeves": const Color.fromRGBO(32,27,26,1),
  "Lagoon - Matte Dual Sleeves": const Color.fromRGBO(87,138,174,1),
  "Lime - Matte Sleeves": const Color.fromRGBO(154,184,85,1),
  "Magenta - Matte Sleeves": const Color.fromRGBO(175,27,86,1),
  "Midnight Blue - Matte Sleeves": const Color.fromRGBO(0,35,67,1),
  "Might - Dual Matte Sleeves": const Color.fromRGBO(0,102,60,1),
  "Mint - Classic Sleeves": const Color.fromRGBO(81,179,154,1),
  "Mint - Matte Sleeves": const Color.fromRGBO(0,192,157,1),
  "Nebula - Matte Sleeves": const Color.fromRGBO(125,105,178,1),
  "Night Blue - Classic Sleeves": const Color.fromRGBO(19,20,68,1),
  "Night Blue - Matte Sleeves": const Color.fromRGBO(15,14,58,1),
  "Olive - Matte Sleeves": const Color.fromRGBO(110,142,36,1),
  "Orchid - Matte Dual Sleeves": const Color.fromRGBO(187,168,197,1),
  "Peach - Matte Dual Sleeves": const Color.fromRGBO(244,133,127,1),
  "Petrol - Matte Sleeves": const Color.fromRGBO(0,89,100,1),
  "Pink - Matte Sleeves": const Color.fromRGBO(238,150,169,1),
  "Pink Diamond - Matte Sleeves": const Color.fromRGBO(226,111,169,1),
  "Purple - Classic Sleeves": const Color.fromRGBO(68,50,95,1),
  "Purple - Matte Sleeves": const Color.fromRGBO(66,47,94,1),
  "Silver - Classic Sleeves": const Color.fromRGBO(137,138,138,1),
  "Silver - Matte Sleeves": const Color.fromRGBO(161,157,154,1),
  "Sky Blue - Matte Sleeves": const Color.fromRGBO(0,123,169,1),
  "Slate - Matte Sleeves": const Color.fromRGBO(47,43,44,1),
  "Snow - Matte Dual Sleeves": const Color.fromRGBO(252,251,251,1),
  "Tangerine - Classic Sleeves": const Color.fromRGBO(232,79,14,1),
  "Turquoise - Players' Choice Matte Sleeves": const Color.fromRGBO(0,149,173,1),
  "Valor - Dual Matte Sleeves": const Color.fromRGBO(254,245,217,1),
  "White - Classic Sleeves": const Color.fromRGBO(224,224,224,1),
  "White - Matte Sleeves": const Color.fromRGBO(220,222,220,1),
  "Wisdom - Dual Matte Sleeves": const Color.fromRGBO(0,77,155,1),
  "Yellow - Matte Sleeves": const Color.fromRGBO(236,198,0,1),
};

Map originalColors = {
  "NULL":Colors.transparent,
  "Apple Green - Matte Sleeves": const Color.fromRGBO(0,158,75,1),
  "Blood Red - Matte Sleeves": const Color.fromRGBO(133,36,53,1),
  "Black - Classic Sleeves": const Color.fromRGBO(32,27,27,1),
  "Black - Matte Sleeves": const Color.fromRGBO(25,21,22,1),
  "Blue - Classic Sleeves": const Color.fromRGBO(4,90,134,1),
  "Blue - Matte Sleeves": const Color.fromRGBO(0,57,118,1),
  "Brown - Classic Sleeves": const Color.fromRGBO(80,37,16,1),
  "Copper - Classic Sleeves": const Color.fromRGBO(146,73,39,1),
  "Copper - Matte Sleeves": const Color.fromRGBO(176,87,59,1),
  "Crimson - Classic Sleeves": const Color.fromRGBO(185,32,24,1),
  "Crimson - Matte Sleeves": const Color.fromRGBO(190,9,23,1),
  "Crypt - Matte Dual Sleeves": const Color.fromRGBO(132,126,115,1),
  "Ember - Dual Matte Sleeves": const Color.fromRGBO(215,74,40,1),
  "Emerald - Matte Sleeves": const Color.fromRGBO(4,85,40,1),
  "Eucalyptus - Matte Dual Sleeves": const Color.fromRGBO(167,213,189,1),
  "Forest Green - Matte Sleeves": const Color.fromRGBO(65,94,65,1),
  "Fury - Dual Matte Sleeves": const Color.fromRGBO(203,0,67,1),
  "Glacier - Matte Dual Sleeves": const Color.fromRGBO(0,158,170,1),
  "Gold - Classic Sleeves": const Color.fromRGBO(148,98,38,1),
  "Gold - Matte Sleeves": const Color.fromRGBO(166,97,17,1),
  "Green - Classic Sleeves": const Color.fromRGBO(0,112,88,1),
  "Green - Matte Sleeves": const Color.fromRGBO(0,89,53,1),
  "Ivory - Matte Sleeves": const Color.fromRGBO(228,220,193,1),
  "Jet - Matte Sleeves": const Color.fromRGBO(32,27,26,1),
  "Lagoon - Matte Dual Sleeves": const Color.fromRGBO(87,138,174,1),
  "Lightning - Matte Dual Sleeves": const Color.fromRGBO(234,220,69,1),
  "Lime - Matte Sleeves": const Color.fromRGBO(154,184,85,1),
  "Magenta - Matte Sleeves": const Color.fromRGBO(175,27,86,1),
  "Midnight Blue - Matte Sleeves": const Color.fromRGBO(0,35,67,1),
  "Might - Dual Matte Sleeves": const Color.fromRGBO(0,102,60,1),
  "Mint - Classic Sleeves": const Color.fromRGBO(81,179,154,1),
  "Mint - Matte Sleeves": const Color.fromRGBO(0,192,157,1),
  "Nebula - Matte Sleeves": const Color.fromRGBO(125,105,178,1),
  "Night Blue - Classic Sleeves": const Color.fromRGBO(19,20,68,1),
  "Night Blue - Matte Sleeves": const Color.fromRGBO(15,14,58,1),
  "Olive - Matte Sleeves": const Color.fromRGBO(110,142,36,1),
  "Orange - Matte Sleeves": const Color.fromRGBO(248,154,0,1),
  "Orchid - Matte Dual Sleeves": const Color.fromRGBO(187,168,197,1),
  "Peach - Matte Dual Sleeves": const Color.fromRGBO(244,133,127,1),
  "Petrol - Matte Sleeves": const Color.fromRGBO(0,89,100,1),
  "Pink - Matte Sleeves": const Color.fromRGBO(238,150,169,1),
  "Pink Diamond - Matte Sleeves": const Color.fromRGBO(226,111,169,1),
  "Purple - Classic Sleeves": const Color.fromRGBO(68,50,95,1),
  "Purple - Matte Sleeves": const Color.fromRGBO(66,47,94,1),
  "Red - Matte Sleeves": const Color.fromRGBO(159,32,43,1),
  "Ruby - Matte Sleeves": const Color.fromRGBO(165,25,31,1),
  "Sapphire - Matte Sleeves": const Color.fromRGBO(11,135,192,1),
  "Silver - Classic Sleeves": const Color.fromRGBO(137,138,138,1),
  "Silver - Matte Sleeves": const Color.fromRGBO(161,157,154,1),
  "Sky Blue - Matte Sleeves": const Color.fromRGBO(0,123,169,1),
  "Slate - Matte Sleeves": const Color.fromRGBO(47,43,44,1),
  "Snow - Matte Dual Sleeves": const Color.fromRGBO(252,251,251,1),
  "Tangerine - Classic Sleeves": const Color.fromRGBO(232,79,14,1),
  "Tangerine - Matte Sleeves": const Color.fromRGBO(233,79,13,1),
  "Turquoise - Players' Choice Matte Sleeves": const Color.fromRGBO(0,149,173,1),
  "Valor - Dual Matte Sleeves": const Color.fromRGBO(254,245,217,1),
  "White - Classic Sleeves": const Color.fromRGBO(224,224,224,1),
  "White - Matte Sleeves": const Color.fromRGBO(220,222,220,1),
  "Wisdom - Dual Matte Sleeves": const Color.fromRGBO(0,77,155,1),
  "Wraith - Dual Matte Sleeves": const Color.fromRGBO(124,34,87,1),
  "Yellow - Matte Sleeves": const Color.fromRGBO(236,198,0,1),
};

BoxDecoration lifepadBoxDecoration(Color color){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: color.withOpacity(0.5),
    boxShadow: [
      BoxShadow(
        color: color,
        blurRadius: 1
      )
    ],
  );
}

TextStyle boldTextStyle({Color color = Colors.white}){
  return TextStyle(
    fontWeight: FontWeight.bold,
    color: color,
    shadows: [
      Shadow(
        color: color,
        blurRadius: 1,
      )
    ],
  );
}

BoxConstraints infinityBoxConstraints(){
  return BoxConstraints.expand(width: double.infinity,height: double.infinity);
}

EdgeInsets lifepadPadding(LifePad widget){
  return EdgeInsets.only(
    right: (
      widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0 ||
      widget.numberOfPlayers % 2 != 0 && widget.id < widget.numberOfPlayers?
      5:8
    ),
    left: (
      widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0 ||
      widget.numberOfPlayers % 2 != 0 && widget.id < widget.numberOfPlayers?
      5:8
    ),
    bottom: 8,
    top: 5
  );
}