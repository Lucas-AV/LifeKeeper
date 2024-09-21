import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_screen.dart';
import 'package:lifekeeper/universal.dart' as universal;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CircleMenuButton extends StatefulWidget {
  const CircleMenuButton({super.key, required this.opennedMenu});
  final bool opennedMenu;

  @override
  State<CircleMenuButton> createState() => _CircleMenuButtonState();
}

class _CircleMenuButtonState extends State<CircleMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.white54, blurRadius: 2, spreadRadius: 1),
          BoxShadow(color: Colors.black38, blurRadius: 3, spreadRadius: 1)
        ]),
        constraints: BoxConstraints.tightFor(
          height: widget.opennedMenu ? 110 : 0,
          width: widget.opennedMenu ? 110 : 0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  constraints: BoxConstraints.tightFor(height: widget.opennedMenu ? 40 : 0, width: widget.opennedMenu ? 40 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(MdiIcons.cubeOutline,
                      color: Colors.black.withOpacity(widget.opennedMenu ? 1 : 0), size: widget.opennedMenu ? 24 : 0)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  constraints: BoxConstraints.tightFor(height: widget.opennedMenu ? 40 : 0, width: widget.opennedMenu ? 40 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(MdiIcons.cubeOutline,
                      color: Colors.black.withOpacity(widget.opennedMenu ? 1 : 0), size: widget.opennedMenu ? 24 : 0)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  constraints: BoxConstraints.tightFor(height: widget.opennedMenu ? 40 : 0, width: widget.opennedMenu ? 40 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(MdiIcons.cubeOutline,
                      color: Colors.black.withOpacity(widget.opennedMenu ? 1 : 0), size: widget.opennedMenu ? 24 : 0)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  constraints: BoxConstraints.tightFor(height: widget.opennedMenu ? 40 : 0, width: widget.opennedMenu ? 40 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(MdiIcons.cubeOutline,
                      color: Colors.black.withOpacity(widget.opennedMenu ? 1 : 0), size: widget.opennedMenu ? 24 : 0)),
            ),
          ],
        ),
      ),
    );
  }
}

class GameMattPage extends StatefulWidget {
  const GameMattPage({super.key});

  @override
  State<GameMattPage> createState() => _GameMattPageState();
}

class _GameMattPageState extends State<GameMattPage> {
  bool opennedMenu = false;

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
                      children: List.generate((universal.maxNumberOfPlayers / 2).ceil(), (i) {
                    int pos = i + (universal.maxNumberOfPlayers / 2).ceil() * column;
                    if (pos >= universal.maxNumberOfPlayers) return Container();
                    return LifepadScreen(index: pos);
                  })),
                );
              })),
            ),
            Align(
              alignment: Alignment.center,
              child: RawMaterialButton(
                constraints: BoxConstraints(),
                onPressed: () {
                  setState(() => opennedMenu = !opennedMenu);
                },
                shape: CircleBorder(),
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    constraints: BoxConstraints.tightFor(
                      height: opennedMenu ? 100 : 40,
                      width: opennedMenu ? 100 : 40,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, spreadRadius: 1)]),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Icon(
                          MdiIcons.cubeOutline,
                          color: Colors.white,
                          size: constraints.maxHeight * 0.66,
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
