import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_screen.dart';
import 'package:lifekeeper/universal.dart' as universal;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GameMattPage extends StatefulWidget {
  const GameMattPage({super.key});

  @override
  State<GameMattPage> createState() => _GameMattPageState();
}

class _GameMattPageState extends State<GameMattPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            RotatedBox(
              quarterTurns: universal.maxNumberOfPlayers == 2 ? 1 : 0,
              child: Row(
                  children: List.generate(2, (column) {
                return Expanded(
                  child: Column(
                    children: List.generate(
                      (universal.maxNumberOfPlayers / 2).ceil(), 
                      (i) {
                        int pos = i + (universal.maxNumberOfPlayers / 2).ceil()*column;
                        if (pos >= universal.maxNumberOfPlayers) return Container();
                        return LifepadScreen(
                          index: pos
                        );
                      }
                    )
                  ),
                );
              })
              ),
            ),
            
            Align(
              alignment: Alignment.center,
              child: RawMaterialButton(
                constraints: BoxConstraints(),
                onPressed: () {
                  universal.maxNumberOfPlayers == 2
                      ? setState(() => universal.maxNumberOfPlayers = 6)
                      : setState(() => universal.maxNumberOfPlayers--);
                },
                shape: CircleBorder(),
                child: Container(
                  constraints: BoxConstraints.tightFor(width: 35, height: 35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, 
                        blurRadius: 3, 
                        spreadRadius: 1
                      )
                    ]
                  ),
                  child: Icon(MdiIcons.cubeOutline, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
