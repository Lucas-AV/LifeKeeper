import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'main_page.dart';
import 'dart:async';
import 'main.dart';
import 'dart:math';

class LifePad extends StatefulWidget {
  LifePad({Key? key, this.isAttacking = false, required this.color,this.quarterTurns = 0, this.base = 40, required this.id, required this.numberOfPlayers, this.value = 1}) : super(key: key);
  final int numberOfPlayers;
  final int quarterTurns;
  Color color;
  bool isAttacking;
  final int base;
  final int id;
  int value;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  Timer timeCounter = Timer(Duration(seconds: 0),(){});
  String viewMode = "minimalist";
  int diceTypeRoll = 0;
  DateTime lastClick = DateTime.now();

  @override
  void initState(){
    super.initState();
  }

  Widget counterValueText() {
    return LayoutBuilder(
      builder: (context,constraints){
        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: (constraints.maxWidth > constraints.maxHeight? constraints.maxWidth : constraints.maxHeight) * (0.35),
          color: Colors.transparent,
          child: FittedBox(
            child: Text(
              widget.value.toString(),
              style: boldTextStyle(),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        );
      }
    );
  }
  int delayCheck = 3;
  void checkLastClick() {
    if (DateTime.now().difference(lastClick).inSeconds >= delayCheck && viewMode == "detailed") {
      print("CHECKED");
      setState(() {
        changeViewMode(viewMode!="minimalist", "minimalist", "detailed");
      });
    }
  }

  Widget counterModifierButton({int num = 1}){
    void onPressed(){
      setState(() {
        widget.value += num;
        lastClick = DateTime.now();
        Future.delayed(Duration(seconds: delayCheck), checkLastClick);
      });
    }

    void onLongPress(){
      timeCounter = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          onPressed();
          lastClick = DateTime.now();
          Future.delayed(Duration(seconds: delayCheck), checkLastClick);
        }
      );
    }

    void onLongEnd(LongPressEndDetails details) {
      timeCounter?.cancel();
    }

    return Expanded(
      child: GestureDetector(
        onLongPress: onLongPress,
        onLongPressEnd: onLongEnd,
        child: RawMaterialButton(
          constraints: infinityBoxConstraints(),
          onPressed: onPressed,
        ),
      ),
    );
  }
  Widget modifierColumn(){
    return Row(
      children: [
        counterModifierButton(num: -1),
        counterModifierButton(num: 1),
      ],
    );
  }

  void changeViewMode(bool modeCondition,String isTrue, String isFalse){
    setState(() {
      viewMode = modeCondition? isTrue:isFalse;
      lastClick = DateTime.now();
      Future.delayed(Duration(seconds: delayCheck), checkLastClick);
    });
  }

  Widget diceMultipleOutlineButton(){
    return positionedButton(
      (){
        changeViewMode(viewMode == "rollDice","detailed","rollDice");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.diceMultipleOutline,
      afterIcon: MdiIcons.diceMultiple,
      condition: viewMode == "rollDice",
      position: 'bottomRight',
    );
  }
  Widget paletteOutlineButton(){
    return positionedButton(
      (){
        changeViewMode(viewMode == "colorChange","detailed","colorChange");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.paletteOutline,
      afterIcon: MdiIcons.palette,
      condition: viewMode == "colorChange",
      position: 'bottomLeft',
    );
  }
  Widget cardsOutlinedButton(){
    return positionedButton(
      (){
        changeViewMode(viewMode == "commander","detailed","commander");
      },
      visibleCondition: viewMode != "minimalist",
      initialIcon: MdiIcons.cardsOutline,
      afterIcon: MdiIcons.cards,
      condition: viewMode == "commander",
      position: "topRight",
    );
  }
  Widget tokensButton(){
    return positionedButton(
      (){
        changeViewMode(viewMode == "tokensEdit","detailed","tokensEdit");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.notebookEditOutline,
      afterIcon: MdiIcons.notebookEdit,
      condition: viewMode == "tokensEdit",
      position: 'topLeft',
    );
  }

  Widget closeButton(){
    return positionedButton(
      (){
        changeViewMode(viewMode == "detailed", "minimalist", "detailed");
      },
      position: "topLeft",
      initialIcon: MdiIcons.close,
      afterIcon: MdiIcons.close,
    );
  }

  Widget colorButton({Color color = Colors.red}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: color,
        child: lifepadButtonOpacityDoubleChange(
          (){
            setState(() {
              widget.color = color;
            });
          },
          initialIcon: Icons.check_box_outline_blank,
          afterIcon: Icons.check_box,
          condition: widget.color == color,
        )
      ),
    );
  }


  Widget diceButton({int value = 4}){
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        child: lifepadButtonOpacityDoubleChange(
          (){
            setState(() {
              diceTypeRoll = value;
            });
          },
          initialIcon: dicesMap["outlined"][value],
          afterIcon: dicesMap["normal"][value],
          condition: diceTypeRoll == value,
          multi: 0.8
        )
      ),
    );
  }

  Widget lifeStack(){
    return Stack(
      alignment: Alignment.center,
      children: viewMode == "minimalist"? [
        modifierColumn(),
        counterValueText(),
        SizedBox(
          height: 70,
          width: 70,
          child: GestureDetector(
            onTap: (){
              changeViewMode(viewMode != "minimalist", "minimalist", "detailed");
            },
          ),
        )
      ] : [
        counterValueText(),
        modifierColumn(),
      ],
    );
  }

  Widget detailedStack(){
    return Stack(
      alignment: Alignment.center,
      children: [
        paletteOutlineButton(),
        diceMultipleOutlineButton(),
        cardsOutlinedButton(),
        tokensButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: Padding(
          padding: lifepadPadding(widget),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            decoration: lifepadBoxDecoration(widget.color),
            child: Stack(
              alignment: Alignment.center,
              children: [
                lifeStack(),
                detailedStack(),
                lifepadSection(
                  (){
                    changeViewMode(viewMode == "colorChange","detailed","colorChange");
                  },
                  (){
                    setState(() {
                      widget.color = colorsList[Random().nextInt(colorsList.length)];
                    });
                  },
                  List<Widget>.generate(colorsList.length, (index) => colorButton(color: colorsList[index])),
                  visible: viewMode == "colorChange",
                  color: widget.color,
                  title: "CHOOSE A COLOR"
                ),

                lifepadSection(
                  (){
                    changeViewMode(viewMode == "rollDice", "detailed", "rollDice");
                    diceTypeRoll = 0;
                  },
                  (){
                    setState(() {
                      diceTypeRoll = dicesValues[Random().nextInt(dicesValues.length)];
                    });
                  },
                  List.generate(dicesValues.length, (index) => diceButton(value: dicesValues[index])),
                  visible: viewMode == "rollDice",
                  title: "ROLL A DICE",
                  color: widget.color,
                  crossAxisCount: 4,
                ),

                lifepadSection(
                      (){
                    changeViewMode(viewMode == "tokensEdit", "detailed", "tokensEdit");
                    diceTypeRoll = 0;
                  },
                      (){
                    setState(() {
                      diceTypeRoll = dicesValues[Random().nextInt(dicesValues.length)];
                    });
                  },
                  [
                    Container(color: Colors.red),
                    Container(color: Colors.green),
                    Container(color: Colors.blue),
                  ],
                  visible: viewMode == "tokensEdit",
                  title: "ROLL A DICE",
                  color: widget.color,
                  crossAxisCount: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}