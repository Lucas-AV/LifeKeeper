import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'lifepad.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.numberOfPlayers = 2, this.base = 40}) : super(key: key);
  int numberOfPlayers;
  int base;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    Map playersInfo = {
      "commander":List.generate(widget.numberOfPlayers+1, (index) => List.generate(widget.numberOfPlayers, (subIndex) => 0)),
      "initiative":List.generate(widget.numberOfPlayers+1, (index) => false),
      "attacking":List.generate(widget.numberOfPlayers+1, (index) => false),
      "ascended":List.generate(widget.numberOfPlayers+1, (index) => false),
      "monarch":List.generate(widget.numberOfPlayers+1, (index) => false),
      "life":List.generate(widget.numberOfPlayers+1, (index) => widget.base),
      "numberOfPlayers":widget.numberOfPlayers,
      "base":widget.base,
    };
    double maxHei = MediaQuery.of(context).size.height;
    double maxWid = MediaQuery.of(context).size.width;

    List<Widget> buildChildren(){
      if(widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0){
        return [
          for(int i = 0; i < widget.numberOfPlayers/2; i++)
            Expanded(
              child: (maxHei <= maxWid)?
              Column(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei <= maxWid)? (j == 0? 2:0):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      value: playersInfo['life'][j + i * 2 + 1],
                    )
                ],
              ) :
              Row(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      value: playersInfo['life'][j + i * 2 + 1],
                    )
                ],
              ),
            ),
        ];
      }

      else if(widget.numberOfPlayers % 2 != 0){
        return [
          for(int i = 0; i < (widget.numberOfPlayers - widget.numberOfPlayers%2)/2; i++)
            Expanded(
              child: (maxHei <= maxWid)?
                Column(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei <= maxWid)? (j == 0? 2:0):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      value: playersInfo['life'][j + i * 2 + 1],
                    )
                ],
              ) :
                Row(
                  children: [
                    for(int j = 0; j < 2; j++)
                      LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      value: playersInfo['life'][j + i * 2 + 1],
                    )
                  ],
                ),
            ),
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)?0:3,
            color: colorsList[widget.numberOfPlayers-1],
            id: widget.numberOfPlayers,
            base: widget.base,
            value: playersInfo['life'][widget.numberOfPlayers],
          )
        ];
      }

      return [
        for(int i = 1; i < widget.numberOfPlayers+1; i++)
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)? (i == 1? 2:0):(i == 1? 1:3),
            color: colorsList[i-1],
            id: i,
            base: widget.base,
            value: playersInfo['life'][i],
          )
      ];
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: maxHei,
          width: maxWid,
          child: Stack(
            alignment: Alignment.center,
            children: [
              (maxHei >= maxWid)?
              Column(
                children: buildChildren(),
              ) :
              Row(
                children: buildChildren(),
              ),
            ],
          )
        ),
      ),
    );
  }
}
