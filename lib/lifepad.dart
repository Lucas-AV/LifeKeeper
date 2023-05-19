import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'main_page.dart';
import 'dart:async';
import 'main.dart';
import 'dart:math';

class LifePad extends StatefulWidget {
  LifePad({Key? key, this.isAttacking = false, required this.color,this.quarterTurns = 0, this.base = 40, required this.id, required this.numberOfPlayers, required this.playersInfo}) : super(key: key);
  final int numberOfPlayers;
  final int quarterTurns;
  Color color;
  final Map playersInfo;
  bool isAttacking;
  final int base;
  final int id;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  Timer timeCounterAdd = Timer(Duration(seconds: 0),(){});
  Timer timeCounterDec = Timer(Duration(seconds: 0),(){});
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
              widget.playersInfo['life'][widget.id].toString(),
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
        widget.playersInfo['life'][widget.id] += num;
        lastClick = DateTime.now();
        Future.delayed(Duration(seconds: delayCheck), checkLastClick);
      });
    }

    void onLongPress(){
      if(num == 1){
        timeCounterAdd = Timer.periodic(
            const Duration(milliseconds: 100),
                (timer) {
              onPressed();
              lastClick = DateTime.now();
              Future.delayed(Duration(seconds: delayCheck), checkLastClick);
            }
        );
      } else {
        timeCounterDec = Timer.periodic(
            const Duration(milliseconds: 100),
                (timer) {
              onPressed();
              lastClick = DateTime.now();
              Future.delayed(Duration(seconds: delayCheck), checkLastClick);
            }
        );
      }
    }

    void onLongEnd(LongPressEndDetails details) {
      num == 1? timeCounterAdd?.cancel() : timeCounterDec?.cancel();
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
    return PositionedButton(
      onPressed: (){
        changeViewMode(viewMode == "rollDice","detailed","rollDice");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.diceMultipleOutline,
      afterIcon: MdiIcons.diceMultiple,
      condition: viewMode == "rollDice",
      // position: 'n',
    );
  }
  Widget paletteOutlineButton(){
    return PositionedButton(
      onPressed: (){
        changeViewMode(viewMode == "colorChange","detailed","colorChange");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.paletteOutline,
      afterIcon: MdiIcons.palette,
      condition: viewMode == "colorChange",
      // position: 'n',
    );
  }
  Widget cardsOutlinedButton(){
    return PositionedButton(
      onPressed: (){
        changeViewMode(viewMode == "commander","detailed","commander");
      },
      visibleCondition: viewMode != "minimalist",
      initialIcon: MdiIcons.cardsOutline,
      afterIcon: MdiIcons.cards,
      condition: viewMode == "commander",
      // position: "topRight",
    );
  }
  Widget tokensButton(){
    return PositionedButton(
      onPressed: (){
        changeViewMode(viewMode == "tokensEdit","detailed","tokensEdit");
      },
      visibleCondition: viewMode != 'minimalist',
      initialIcon: MdiIcons.notebookEditOutline,
      afterIcon: MdiIcons.notebookEdit,
      condition: viewMode == "tokensEdit",
      // position: 'topLeft',
    );
  }
  Widget buttonRow(Function left, Function right, {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end}){
    return Column(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Row(
            children: [
              left(),
              Expanded(child: SizedBox()),
              right(),
            ],
          ),
        ],
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
              widget.playersInfo['colors'][widget.id-1] = color;
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


  @override
  Widget build(BuildContext context) {
    double maxHei = MediaQuery.of(context).size.height;
    double maxWid = MediaQuery.of(context).size.width;
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
                ButtonRow(
                  leftButton: tokensButton(),
                  rightButton: cardsOutlinedButton(),
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                ButtonRow(
                  leftButton: paletteOutlineButton(),
                  rightButton: diceMultipleOutlineButton(),
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                LifepadSection(
                  onClose: (){
                    changeViewMode(viewMode == "colorChange","detailed","colorChange");
                  },
                  onRandom: (){
                    setState(() {
                      widget.color = colorsList[Random().nextInt(colorsList.length)];
                    });
                  },
                  visible: viewMode == "colorChange",
                  color: widget.color,
                  title: "CHOOSE A COLOR",
                  children: List<Widget>.generate(colorsList.length, (index) => colorButton(color: colorsList[index])),
                ),
                LifepadSection(
                  onClose: (){
                    changeViewMode(viewMode == "rollDice", "detailed", "rollDice");
                    diceTypeRoll = 0;
                  },
                  onRandom: (){
                    setState(() {
                      diceTypeRoll = dicesValues[Random().nextInt(dicesValues.length)];
                    });
                  },
                  visible: viewMode == "rollDice",
                  title: "ROLL A DICE",
                  color: widget.color,
                  crossAxisCount: 4,
                  children: List.generate(dicesValues.length, (index) => diceButton(value: dicesValues[index])),
                ),
                LifepadSection(
                  onClose: (){
                    changeViewMode(viewMode == "tokensEdit", "detailed", "tokensEdit");
                    diceTypeRoll = 0;
                  },
                  onRandom: (){
                    setState(() {
                      diceTypeRoll = dicesValues[Random().nextInt(dicesValues.length)];
                    });
                  },
                  visible: viewMode == "tokensEdit",
                  color: widget.color,
                  crossAxisCount: 3,
                  title: "COUNTERS",
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.transparent,
                        // decoration: BoxDecoration(
                        //   color: widget.color,
                        //   boxShadow:[
                        //     BoxShadow(
                        //       color: Colors.black26,
                        //       blurRadius: 10,
                        //       offset: Offset(0,11),
                        //     )
                        //   ]
                        // ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: RawMaterialButton(
                                      onPressed: (){},
                                      child: SizedBox(
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: RawMaterialButton(
                                      onPressed: (){},
                                      child: SizedBox(
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}