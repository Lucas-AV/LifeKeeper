import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'main_page.dart';
import 'dart:async';
import 'main.dart';
import 'dart:math';

class LifePad extends StatefulWidget {
  LifePad({Key? key, this.rollDiceType = 20,this.isPlaying = true,this.isAttacking = false, required this.color,this.quarterTurns = 0, this.base = 40, required this.id, required this.numberOfPlayers, required this.playersInfo}) : super(key: key);
  final int numberOfPlayers;
  final int quarterTurns;
  Color color;
  final Map playersInfo;
  bool isAttacking;
  final int base;
  final int id;
  bool isPlaying;
  int rollDiceType;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  Timer timeCounterAdd = Timer(Duration(seconds: 0),(){});
  Timer timeCounterDec = Timer(Duration(seconds: 0),(){});
  String viewMode = "minimalist";
  int diceTypeRoll = 0;
  DateTime lastClick = DateTime.now();
  bool isFirst = false;
  bool soloRolling = false;
  bool isDead = false;

  // MdiIcons.skullOutlined

  bool everyTrue(){
    for(int i = 0; i < 8; i++){
      if(!widget.playersInfo['rolling'][i]){
        return false;
      }
    }
    return true;
  }

  bool rollWinner(){
    List rollValues = widget.playersInfo['diceValues'].sublist(1,widget.numberOfPlayers+1);
    rollValues.sort();
    for(int i = 0; i < 8; i++){
      if(widget.playersInfo['diceValues'][widget.id] != rollValues.last){
        return false;
      }
    }
    return true;
  }

  void start() async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isFirst = widget.id == widget.playersInfo['starter'];
    });
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        isFirst = false;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    if(widget.isPlaying){
      start();
    }
  }


  Widget counterValueText() {
    return LayoutBuilder(
      builder: (context,constraints){
        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: (constraints.maxWidth > constraints.maxHeight? constraints.maxWidth : constraints.maxHeight) * (0.35),
          child: FittedBox(
            child: Text(
              widget.isPlaying? widget.playersInfo['life'][widget.id].toString() :
              '${widget.playersInfo['diceValues'][widget.id] < 10?0:''}${widget.playersInfo['diceValues'][widget.id]}',
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
      setState(() {
        changeViewMode(viewMode!="minimalist", "minimalist", "detailed");
      });
    }
  }

  Widget counterModifierButton({int num = 1, int idx = 0, String mode = ''}){
    void onPressed(){
      setState(() {
        if(mode == "commander"){
          widget.playersInfo['commander'][widget.id][idx] += num;
        } else {
          widget.playersInfo['life'][widget.id] += num;
        }
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
      multi: widget.numberOfPlayers == 6 || widget.numberOfPlayers == 5 && widget.id != widget.numberOfPlayers? .66:.7,
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
      multi: widget.numberOfPlayers == 6 || widget.numberOfPlayers == 5 && widget.id != widget.numberOfPlayers? .66:.7,
      // position: 'n',
    );
  }
  Widget cardsOutlinedButton(){
    return Visibility(
      visible: viewMode == "detailed",
      child: Padding(
        padding: const EdgeInsets.only(right: 2,top: 2),
        child: RawMaterialButton(
          constraints: BoxConstraints(maxWidth: 45,maxHeight: 45,minWidth: 45,minHeight: 45),
          onPressed: (){
            changeViewMode(viewMode == "commander","detailed","commander");
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset("assets/commander.png",color: Colors.white,),
          ),
        ),
      ),
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
      multi: widget.numberOfPlayers == 6 || widget.numberOfPlayers == 5 && widget.id != widget.numberOfPlayers? .66:.7,
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
        SizedBox(
          height: 10,
          width: 1,
        )
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

  late int last;
  Future<void> rollDicePlus(int idx,int max) async {
    for(int i = 0; i < 50; i++){
      if(i != 0){
        await Future.delayed(const Duration(milliseconds: 5));
      }
      setState((){
        last = widget.playersInfo["diceValues"][idx];
        while(widget.playersInfo["diceValues"][idx] == last){
          widget.playersInfo["diceValues"][idx] = Random().nextInt(max) + 1;
        }
      });
    }
    setState(() {
      widget.playersInfo["rolling"][idx] = true;
    });
  }

  Widget commanderButton({int idx = 0}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.playersInfo['colors'][idx-1],
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              color: Colors.black38,
              blurRadius: 5
            )
          ]
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        child: FittedBox(child: Text(widget.playersInfo['commander'][widget.id][idx].toString(),style: boldTextStyle()))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: SizedBox(
                      width: double.infinity,
                      height: 18,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FittedBox(
                          child: Text("Player $idx",style: boldTextStyle()),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                counterModifierButton(num: -1,idx: idx,mode: "commander"),
                counterModifierButton(num: 1,idx: idx,mode: "commander"),
              ],
            ),
          ],
        ),
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
              widget.isPlaying = false;
              soloRolling = true;
              diceTypeRoll = value;
              viewMode = "minimalist";
              rollDicePlus(widget.id, value);
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
        Positioned(
          bottom: 10,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 750),
            opacity: isFirst? 1:0,
            child: Text("FIRST PLAYER",style: boldTextStyle())
          ),
        ),
        modifierColumn(),
        counterValueText(),
        SizedBox(
          height: 90,
          width: 90,
          child: GestureDetector(
            onTap: (){
              changeViewMode(viewMode != "minimalist", "minimalist", "detailed");
            },
          ),
        ),
      ] : [
        counterValueText(),
        modifierColumn(),
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
                widget.isPlaying?lifeStack():counterValueText(),

                if(!widget.isPlaying)
                  Positioned(
                    bottom: 10,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: everyTrue() && rollWinner() || soloRolling? 1:0,
                      child: Text(soloRolling? "ROLLING A D$diceTypeRoll":"WINNER!",style: boldTextStyle())
                    )
                  ),

                if(soloRolling)
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        widget.playersInfo["diceValues"][widget.id] = 0;
                        widget.isPlaying = true;
                        soloRolling = false;
                      });
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),

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
                // commander
                LifepadSection(
                  onClose: (){
                    changeViewMode(viewMode == "commander", "detailed", "commander");
                  },
                  onRandom: (){},
                  visible: viewMode == "commander",
                  title: "COMMANDER",
                  color: widget.color,
                  crossAxisCount: 3,
                  children: List.generate(widget.numberOfPlayers, (index) => commanderButton(idx: index+1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}