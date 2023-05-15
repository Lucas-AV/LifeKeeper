import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'lifepad.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.numberOfPlayers = 6}) : super(key: key);
  final int numberOfPlayers;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double maxHei = MediaQuery.of(context).size.height;
    double maxWid = MediaQuery.of(context).size.width;

    List<Widget> buildChildren(){
      if(widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0){
        return [
          for(int i = 0; i < widget.numberOfPlayers/2; i++)
            Expanded(
              child: Row(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1],
                      id: j + i * 2 + 1,
                    ),
                ],
              ),
            ),
        ];
      }

      else if(widget.numberOfPlayers % 2 != 0){
        return [
          for(int i = 0; i < (widget.numberOfPlayers - widget.numberOfPlayers%2)/2; i++)
            Expanded(
              child: Row(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: colorsList[j + i * 2 + 1],
                      id: j + i * 2 + 1,
                    ),
                ],
              ),
            ),
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)?0:3,
            color: colorsList[widget.numberOfPlayers],
            id: widget.numberOfPlayers,
          ),
        ];
      }

      return [
        for(int i = 1; i < 3; i++)
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)? (i == 1? 2:0):(i == 1? 1:3),
            color: colorsList[i],
            id: i,
          ),
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
