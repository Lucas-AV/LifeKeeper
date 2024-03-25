import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'style.dart';
import 'dart:async';
import 'dart:math';

Timer blankCounter = Timer(Duration(seconds: 0),(){});


class LifePad extends StatefulWidget {
  LifePad({Key? key, this.rollDiceType = 20,this.isPlaying = true,required this.color,this.quarterTurns = 0, this.base = 40, required this.id, required this.numberOfPlayers, required this.playersInfo}) : super(key: key);
  final int numberOfPlayers;
  final int quarterTurns;
  Color color;
  final Map playersInfo;
  final int base;
  final int id;
  bool isPlaying;
  int rollDiceType;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  // Basic ADD // DEC
  Timer timeCounterLife = blankCounter;
  Map<String,Timer> timeCounterMisc = Map.fromIterables(
    ["infect","energy","experience","treasure","cmd. tax"],
    List.generate(5, (index) => blankCounter)
  );
  List<Timer> timeCounterCMD = List.generate(6, (index) => blankCounter);

  String viewMode = "minimalist";
  int diceTypeRoll = 0;
  int temporaryValue = 0;
  DateTime lastClick = DateTime.now();
  DateTime lastTemp = DateTime.now();
  double opacityTemp = 0;
  bool isFirst = false;
  bool soloRolling = false;
  bool showPlayer = false;

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
    timeCounterLife.cancel();
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
              style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        );
      }
    );
  }

  int delayCheck = 3;
  void checkLastClick() async {
    if (DateTime.now().difference(lastClick).inSeconds >= delayCheck) {
      setState(() {
        opacityTemp = 0;
        Future.delayed(Duration(milliseconds: 200)).then((value) => temporaryValue = 0);
        if(viewMode == "detailed"){
          changeViewMode(viewMode!="minimalist", "minimalist", "detailed");
        }
      });
    }
  }

  void onPressed({int num = 1, int idx = 0, String type = 'life'}){
    setState(() {
      if(type == "commander"){
        widget.playersInfo['commander'][widget.id][idx] += num;
        if(widget.playersInfo['commander'][widget.id][idx] < 0){
          widget.playersInfo['commander'][widget.id][idx] = 0;
        } else {
          widget.playersInfo['life'][widget.id] += num*(-1);
        }
      }
      else {
        widget.playersInfo[type][widget.id] += num;
        if(timeCounterMisc.keys.contains(type)){
          if(widget.playersInfo[type][widget.id] < 0){
            widget.playersInfo[type][widget.id] = 0;
          }
        }

        if(type == 'life') temporaryValue += num;
        if(temporaryValue == 0) opacityTemp = 0;
        if(!isFirst && temporaryValue != 0) opacityTemp = 1;
      }
    });

    lastClick = DateTime.now();
    lastTemp = DateTime.now();
    Future.delayed(Duration(seconds: delayCheck),checkLastClick);
  }

  Widget counterModifierButton({int num = 1, int idx = 0, String type = 'life'}){
    void onLongPress(){
      setState(() {
        widget.playersInfo['activeTemp'][widget.id] = true;
      });

      if(type == 'life'){
        timeCounterLife = Timer.periodic(
          const Duration(milliseconds: 100),
          (timer) => onPressed(num: num,idx: idx,type: type)
        );
      }
      else if(type == "commander"){
        timeCounterCMD[idx] = Timer.periodic(
         const Duration(milliseconds: 100),
          (timer) => onPressed(num: num,idx: idx,type: type)
        );
      }
      else{
        timeCounterMisc[type] = Timer.periodic(
          const Duration(milliseconds: 100),
          (timer) => onPressed(num: num,idx: idx,type: type)
        );
      }
    }

    void onLongEnd(LongPressEndDetails details) {
      setState(() {
        widget.playersInfo['activeTemp'][widget.id] = false;
      });
      timeCounterLife.cancel();
      timeCounterCMD[idx].cancel();
      timeCounterMisc[type]!.cancel();
    }

    return Expanded(
      child: GestureDetector(
        onLongPress: onLongPress,
        onLongPressEnd: onLongEnd,
        child: RawMaterialButton(
          constraints: infinityBoxConstraints(),
          onPressed: (){
            onPressed(num: num,idx: idx,type: type);
          },
        ),
      ),
    );
  }

  Widget modifierColumn(){
    return Column(
      children: [
        counterModifierButton(num: 1),
        counterModifierButton(num: -1),
      ],
    );
  }

  void changeViewMode(bool modeCondition,String isTrue, String isFalse){
    setState(() {
      if(isAllCountersOff()) {
        viewMode = modeCondition ? isTrue : isFalse;
        lastClick = DateTime.now();
        Future.delayed(Duration(seconds: delayCheck), checkLastClick);
      }
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
      color: widget.color == Colors.white? Colors.black:Colors.white,
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
      color: widget.color == Colors.white? Colors.black:Colors.white,
    );
  }
  Widget shieldButton(){
    Color miniColor = widget.color;
    maxValue(){
      var bigger = widget.playersInfo['commander'][widget.id][0];
      int idx = 0;
      for(var i in widget.playersInfo['commander'][widget.id]){
        if(i > bigger){
          bigger = i;
          // miniColor = widget.playersInfo['colors'][idx-1];
        }
        idx++;
      }
      return bigger;
    }

    bool allIsZero = widget.playersInfo['commander'][widget.id].every((element) => element == 0);
    return Visibility(
      visible: (viewMode == "detailed" || viewMode == "minimalist" && !allIsZero) && !soloRolling && widget.isPlaying,
      child: Row(
        children: [
          Padding(
            padding: allIsZero? EdgeInsets.only(left: 2,top: 2) : EdgeInsets.only(left: 0,bottom: 10),
            child: GestureDetector(
              onTap: (){
                changeViewMode(viewMode == "commander","detailed","commander");
              },
              child: Container(
                color: Colors.transparent,
                width: 50,
                height: 45,
                child: allIsZero? Padding(
                  padding: const EdgeInsets.all(2),
                  child: ResponsiveIcon(
                    icon: MdiIcons.shieldHalfFull,
                    color: widget.color == Colors.white? Colors.black:Colors.white
                  ),
                ) : Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: FittedBox(
                          child: Text(
                            maxValue().toString(),
                            textAlign: TextAlign.center,
                            style: boldTextStyle(
                                color: widget.color == Colors.white?
                                Colors.black:Colors.white
                            ),
                          )
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: miniColor.withOpacity(0.5),
                            boxShadow:[
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(0,3)
                              ),
                              BoxShadow(
                                color: widget.color,
                                blurRadius: 1,
                              ),
                            ]
                        ),
                        child: ResponsiveIcon(
                          icon: MdiIcons.shieldHalfFull,
                          color: widget.color == Colors.white? Colors.black:Colors.white,
                          multi: .8,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if(!allIsZero)
            GestureDetector(
              onTap: (){
                changeViewMode(viewMode == "commander","detailed","commander");
              },
              child: SizedBox(width: 4)
            ),
        ],
      ),
    );
  }
  Widget tokensButton(){
    return Visibility(
      visible: (viewMode == "detailed" ||
      widget.playersInfo['infect'][widget.id] != 0 &&
      viewMode == "minimalist") && !soloRolling && widget.isPlaying,
      child: Padding(
        padding: widget.playersInfo['infect'][widget.id] == 0? EdgeInsets.only(left: 2,top: 2) : EdgeInsets.only(left: 0,bottom: 10),
        child: GestureDetector(
          onTap: (){
            changeViewMode(viewMode == "tokensEdit","detailed","tokensEdit");
          },
          child: Container(
            color: Colors.transparent,
            width: 50,
            height: 45,
            child: viewMode == 'detailed' && widget.playersInfo['infect'][widget.id] == 0? Padding(
              padding: const EdgeInsets.all(2),
              child: ResponsiveIcon(
                  icon: MdiIcons.cardsOutline,
                  color: widget.color == Colors.white? Colors.black:Colors.white
              ),
            ) : Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: FittedBox(
                    child: Text(
                      widget.playersInfo['infect'][widget.id].toString(),
                      textAlign: TextAlign.center,
                      style: boldTextStyle(
                        color: widget.color == Colors.white?
                        Colors.black:Colors.white
                      ),
                    )
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: widget.color.withOpacity(0.5),
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0,3)
                        ),
                        BoxShadow(
                          color: widget.color,
                          blurRadius: 1,
                        ),
                      ]
                    ),
                    child: ResponsiveIcon(
                      icon: MdiIcons.skull,
                      color: widget.color == Colors.white? Colors.black:Colors.white,
                      multi: .8,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
          iconColor: color == Colors.white? Colors.black:Colors.white,
          initialIcon: Icons.check_box_outline_blank,
          afterIcon: Icons.check_box,
          condition: widget.color == color,
        )
      ),
    );
  }

  late int last;
  Future<void> rollDicePlus(int idx,int max) async {
    for(int i = 0; i < 125; i++){
      if(i != 0){
        await Future.delayed(const Duration(milliseconds: 5));
      }
      setState((){
        last = widget.playersInfo["diceValues"][idx];
        while(widget.playersInfo["diceValues"][idx] == last){
          widget.playersInfo["diceValues"][idx] = Random().nextInt(99) + 1;
        }
      });
    }
    setState(() {
      widget.playersInfo["diceValues"][idx] = Random().nextInt(max) + 1;
      widget.playersInfo["rolling"][idx] = true;
    });
  }


  Widget counterButton({String type = ''}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
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
                        child: FittedBox(
                          child: Text(
                            widget.playersInfo[type][widget.id].toString(),
                            style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white),
                            textAlign: TextAlign.center,
                          )
                        )
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
                          child: Text(type.toUpperCase(),style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                counterModifierButton(num: 1,idx: widget.id,type: type),
                counterModifierButton(num: -1,idx: widget.id,type: type),
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
          iconColor: widget.color == Colors.white? Colors.black:Colors.white,
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
            child: Container(
              color: widget.color,
              child: Text("FIRST PLAYER",style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white)))
          ),
        ),
        counterValueText(),
        modifierColumn(),
        SizedBox(
          height: !timeCounterLife.isActive?80:0,
          width: !timeCounterLife.isActive?80:0,
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

  Widget tempCounter(){
    return Positioned(
      bottom: 10,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: opacityTemp,
        child: Text(temporaryValue.toString(),style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white))
      ),
    );
  }
  Widget commanderButton({int idx = 0}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
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
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                          child: Text(
                            widget.playersInfo['commander'][widget.id][idx].toString(),
                            textAlign: TextAlign.center,
                            style: boldTextStyle(
                              color: widget.playersInfo['colors'][idx-1] == Colors.white?
                              Colors.black:Colors.white
                            ),
                          )
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SizedBox(
                    width: double.infinity,
                    height: 18,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        child: Text(
                          "Player $idx",
                          style: boldTextStyle(
                            color: widget.playersInfo['colors'][idx-1] == Colors.white?
                            Colors.black:Colors.white
                          )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                counterModifierButton(num: 1,idx: idx,type: "commander"),
                counterModifierButton(num: -1,idx: idx,type: "commander"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isAnyCounterActive(){
    return timeCounterLife.isActive ||
    timeCounterMisc.values.any((element) => element.isActive) ||
    timeCounterCMD.any((element) => element.isActive);
  }
  bool isAllCountersOff(){
    return !timeCounterLife.isActive &&
    timeCounterMisc.values.every((element) => !element.isActive) &&
    timeCounterCMD.every((element) => !element.isActive);
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isPlaying || widget.playersInfo['life'][widget.id] <= 0){
      timeCounterLife.cancel();
      widget.playersInfo["activeTemp"][widget.id] = false;
    }
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
                if(isAnyCounterActive())
                  SizedBox(),
                tempCounter(),
                widget.isPlaying?lifeStack():counterValueText(),

                if(!widget.isPlaying)
                  Positioned(
                    bottom: 10,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: everyTrue() && rollWinner() || soloRolling? 1:0,
                      child: Container(
                          color: widget.color,
                          child: Text(soloRolling? "ROLLING A D$diceTypeRoll":"WINNER!",style: boldTextStyle(color: widget.color == Colors.white? Colors.black:Colors.white)))
                    )
                  ),

                if(soloRolling)
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        widget.playersInfo["diceValues"][widget.id] = 0;
                        widget.isPlaying = true;
                        viewMode = "rollDice";
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
                  rightButton: shieldButton(),
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
                      widget.isPlaying = false;
                      soloRolling = true;
                      viewMode = "minimalist";
                      rollDicePlus(widget.id, diceTypeRoll);
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
                  },
                  onRandom: (){
                    setState(() {
                      countersList.forEach((element) {
                        widget.playersInfo[element][widget.id] = 0;
                      });
                    });
                  },
                  visible: viewMode == "tokensEdit",
                  color: widget.color,
                  crossAxisCount: 3,
                  title: "COUNTERS",
                  children: List.generate(countersList.length, (index) => counterButton(type: countersList[index]))
                ),

                // commander
                LifepadSection(
                  onClose: (){
                    changeViewMode(viewMode == "commander", "detailed", "commander");
                  },
                  onRandom: (){
                    setState(() {
                      countersList.forEach((element) {
                        widget.playersInfo["commander"][widget.id] = List.generate(8, (index) => 0);
                      });
                    });
                  },
                  visible: viewMode == "commander",
                  title: "COMMANDER",
                  color: widget.color,
                  crossAxisCount: 3,
                  children: List.generate(widget.numberOfPlayers, (index) => commanderButton(idx: index+1)),
                ),

                if(widget.playersInfo['life'][widget.id] <= 0)
                  GestureDetector(
                    onTap: onPressed,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.color,
                      ),
                      child: ResponsiveIcon(
                        color: widget.color == Colors.white? Colors.black.withOpacity(0.16):Colors.white30,
                        icon: MdiIcons.skullOutline,
                        multi: 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}