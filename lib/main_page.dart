
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'lifepad.dart';
import 'style.dart';
import 'dart:async';
import 'dart:math';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.diceValue = 20,this.isPlaying = true, this.numberOfPlayers = 2, this.base = 40, this.passiveColors = const [], required this.playersInfo}) : super(key: key);
  int numberOfPlayers;
  int base;
  int diceValue;
  List passiveColors;
  bool isPlaying;
  final Map playersInfo;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String menuViewMode = "main";
  bool centerButtonClicked = false;
  double maxSize = 80;
  List<Widget> children = [];

  int maxPlayers = 7;
  void changeViewMode(String newMode){
    setState(() {
      menuViewMode = newMode;
    });
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

  @override
  void initState(){
    super.initState();
    if(!widget.isPlaying) {
      setState(() {
        widget.playersInfo['rolling'] = List.generate(maxPlayers+1, (index) => false);
        for (int i = 0; i < 8; i++) {
          rollDicePlus(i, widget.diceValue);
        }
      });
    } else {
      setState(() {
        widget.playersInfo['starter'] = Random().nextInt(widget.numberOfPlayers)+1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FixedExtentScrollController lifeController = FixedExtentScrollController(initialItem: widget.base);
    bool heightBiggerThanWidth() => MediaQuery.of(context).size.height >= MediaQuery.of(context).size.width;
    double maxWid = MediaQuery.of(context).size.width;
    double maxHei = MediaQuery.of(context).size.height;
    double biggerSide = heightBiggerThanWidth()? maxHei:maxWid;
    double smallerSide = heightBiggerThanWidth()? maxWid : maxHei;
    double bottomPosition = (widget.numberOfPlayers <= 4? biggerSide/2 : biggerSide/3) - maxSize/2;



    Column buildLifepadMatt(){
      List<Widget> listPadGenerator(length) => List.generate(length~/2, (index) => Expanded(
        child: Row(
          children: List.generate(2, (jIndex) => LifePad(
            quarterTurns: jIndex == 0? 1:3,
            numberOfPlayers: widget.numberOfPlayers,
            color: widget.playersInfo['colors'][jIndex + index * 2],
            id: jIndex + index * 2 + 1,
            base: widget.base,
            playersInfo: widget.playersInfo,
            isPlaying: widget.isPlaying,
          ))
        )
      ));
      List<Widget> lifepadMatt = [];
      
      if(widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0){
        lifepadMatt = listPadGenerator(widget.numberOfPlayers);
      }
      else if(widget.numberOfPlayers % 2 != 0){
        lifepadMatt = listPadGenerator(widget.numberOfPlayers - widget.numberOfPlayers%2)
          ..add(LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: 0,
            color: widget.playersInfo['colors'][widget.numberOfPlayers-1],
            id: widget.numberOfPlayers,
            base: widget.base,
            playersInfo: widget.playersInfo,
            isPlaying: widget.isPlaying,
          )
        );
      }
      else {
        lifepadMatt = List.generate(widget.numberOfPlayers,
          (index) => LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: index == 0? 2:0,
            color: widget.playersInfo['colors'][index],
            playersInfo: widget.playersInfo,
            isPlaying: widget.isPlaying,
            base: widget.base,
            id: index,
          )
        );
      }

      return Column(children: lifepadMatt);
    }

    void resetPage(){
      setState(() {
        widget.playersInfo["diceValues"] = List.generate(maxPlayers+1, (index) => 0);
        widget.playersInfo["commander"] = List.generate(maxPlayers+1, (index) => List.generate(maxPlayers+1, (subIndex) => 0));
        widget.playersInfo["life"] = List.generate(maxPlayers+1, (index) => widget.base);

        ['initiative','ascended','monarch'].forEach((element) {
          widget.playersInfo[element] = List.generate(maxPlayers+1, (index) => false);
        });

        countersList.forEach((element) {
          widget.playersInfo[element] = List.generate(maxPlayers+1, (index) => 0);
        });

        centerButtonClicked = false;
        widget.isPlaying = true;
      });

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            numberOfPlayers: widget.numberOfPlayers,
            base: widget.base,
            passiveColors: widget.playersInfo["colors"],
            playersInfo: widget.playersInfo,
          )
        )
      );
    }

    Expanded swapPlayerNum(int value) {
      Map<int, dynamic> display = {
        2: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) => Padding(
            padding: EdgeInsets.only(top: 2.0 * index),
            child: Container(
              color: Colors.black,
              height: 15,
              width: 30,
            ),
          ))
        ),
        3: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => Padding(
                  padding: EdgeInsets.only(left: 2.0 * index),
                  child: Container(
                    color: Colors.black,
                    height: 15,
                    width: 14,
                  ),
                ))
              ),
            ),
            Container(
              color: Colors.black,
              height: 15,
              width: 30,
            ),
          ],
        ),
        4: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) => Padding(
            padding: EdgeInsets.only(top: 2.0 * index),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (rowIndex) => Padding(
                padding: EdgeInsets.only(left: 2.0 * rowIndex),
                child: Container(
                  color: Colors.black,
                  height: 14,
                  width: 15,
                ),
              ))
            ),
          ))
        ),
        5: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) => Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (rowIndex) => Padding(
                padding: EdgeInsets.only(left: 2.0 * rowIndex),
                child: Container(
                  color: Colors.black,
                  height: 18 / 2,
                  width: 14,
                ),
              ))
            ),
          ))
          ..add(
            Container(
              color: Colors.black,
              height: 18 / 2,
              width: 30,
            ),
          )
        ),
        6: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => Padding(
            padding: EdgeInsets.only(bottom: index != 2 ? 2 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (rowIndex) => Padding(
                padding: EdgeInsets.only(left: 2.0 * rowIndex),
                child: Container(
                  color: Colors.black,
                  height: 18 / 2,
                  width: 14,
                ),
              ))
            ),
          )),
        )
      };
      return Expanded(
        child: RawMaterialButton(
          onPressed: () {
            setState(() {
              widget.numberOfPlayers = value;
              resetPage();
            });
          },
          child: display[value]
        ),
      );
    }

    Expanded chooseDiceToRoll(int value) {
      return Expanded(
        child: RawMaterialButton(
          onPressed: (){
            setState(() {
              play = false;
              widget.playersInfo['diceValues'] = List.generate(8, (index) => 0);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  numberOfPlayers: widget.numberOfPlayers,
                  base: widget.base,
                  passiveColors: widget.playersInfo["colors"],
                  playersInfo: widget.playersInfo,
                  isPlaying: false,
                  diceValue: value,
                )
              ),
            );
          },
          child: ResponsiveIcon(icon: dicesMap["normal"]![value],color: Colors.black),
        )
      );
    }

    Expanded swapLife(int value){
      return Expanded(
        child: RawMaterialButton(
          onPressed: () {
            setState(() {
              widget.base = value;
              for(int index = 0; index < maxPlayers+1;index++){
                widget.playersInfo['life'][index] = value;
              }
            });
            lifeController.animateToItem(widget.base, duration: const Duration(milliseconds: 450), curve: Curves.easeIn);

          },
          child: Text(
            "$value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            )
          ),
        ),
      );
    }

    Widget centerButton(){
     return Visibility(
        visible: widget.isPlaying,
        child: Positioned(
          bottom: bottomPosition,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: smallerSide,
              minHeight: maxSize
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // MAIN
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: centerButtonClicked? maxSize*.5:0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 1
                      ),
                    ],
                  ),
                  child: Visibility(
                    visible: centerButtonClicked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CenterMenuIconButton(
                                onPressed: () => resetPage(),
                                icon: MdiIcons.refresh,
                                color: Colors.black,
                              ),
                              CenterMenuIconButton(
                                onPressed: () => changeViewMode("players"),
                                icon: MdiIcons.accountGroup,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: maxSize*1.1,
                          height: 40,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              CenterMenuIconButton(
                                onPressed: () => changeViewMode("life"),
                                icon: MdiIcons.heartCog,
                                color: Colors.black,
                              ),
                              CenterMenuIconButton(
                                onPressed: () => changeViewMode("dices"),
                                icon: MdiIcons.diceMultiple,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // PLAYERS
                AnimatedContainer(
                  duration: Duration(milliseconds: 1),
                  width: double.infinity,
                  height: menuViewMode == "players" && centerButtonClicked? maxSize*.5:0,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 1
                      ),
                    ],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5,
                              (index) => swapPlayerNum([2,3,4,5,6][index]))
                        ..insert(2, SizedBox(
                          width: maxSize*1.1,
                          height: 40,
                        )
                        )
                        ..insert(0, CenterMenuIconButton(
                          onPressed: () => setState(() => menuViewMode = "menu"),
                          icon: MdiIcons.arrowLeftBold,
                          color: Colors.black,
                        ),
                        )
                  ),
                ),

                // DICES
                AnimatedContainer(
                  duration: Duration(milliseconds: 1),
                  width: double.infinity,
                  height: menuViewMode == "dices" && centerButtonClicked? maxSize*.5:0,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 1
                      ),
                    ],
                  ),
                  child: Expanded(
                    child: Row(
                        children: List.generate(6,
                                (index) => chooseDiceToRoll([4,6,8,10,12,20][index]))
                          ..insert(0, CenterMenuIconButton(
                            onPressed: () => setState(() => menuViewMode = "menu"),
                            icon: MdiIcons.arrowLeftBold,
                            color: Colors.black,
                          )
                          )
                    ),
                  ),
                ),

                // Life
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1),
                      width: double.infinity,
                      height: menuViewMode == "life" && centerButtonClicked? maxSize*.5:0,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 1
                          ),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5,
                                  (index) => swapLife([20,30,40,50,60][index]))
                            ..insert(2, SizedBox(
                              width: maxSize*1.1,
                              height: 40,
                            )
                            )
                            ..insert(0, CenterMenuIconButton(
                              onPressed: () => setState(() => menuViewMode = "menu"),
                              icon: MdiIcons.arrowLeftBold,
                              color: Colors.black,
                            ),
                            )
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: menuViewMode == "life"?  maxSize:0,
                      width: menuViewMode == "life"?  maxSize:0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: (Colors.white).withOpacity(0.5),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 10)
                            ),
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 1
                            ),
                          ]
                      ),
                    ),
                    Visibility(
                      visible: menuViewMode == "life",
                      child: SizedBox(
                        height: maxSize,
                        width: maxSize,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: menuViewMode == "life"?450:100),
                          opacity: menuViewMode == "life"? 1:0,
                          child: Center(
                            child: LayoutBuilder(
                                builder: (context,constraints){
                                  return ListWheelScrollView.useDelegate(
                                    itemExtent: constraints.maxWidth*0.35,
                                    diameterRatio: 1.5,
                                    perspective: 0.01,
                                    physics: const FixedExtentScrollPhysics(),
                                    controller: lifeController,
                                    childDelegate: ListWheelChildBuilderDelegate(
                                        childCount: 1000,
                                        builder: (context, index) {
                                          return Text(
                                            "$index",
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.5),
                                                shadows: const [Shadow(color: Colors.black, blurRadius: 1)],
                                                fontWeight: FontWeight.bold,
                                                fontSize: constraints.maxWidth*0.3
                                            ),
                                          );
                                        }
                                    ),
                                    onSelectedItemChanged: (value) {
                                      setState(() {
                                        widget.base = value;
                                        for(int index = 0; index < maxPlayers+1;index++){
                                          widget.playersInfo['life'][index] = value;
                                        }
                                      });
                                    },
                                  );
                                }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // BUTTON
                AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: centerButtonClicked?
                    menuViewMode == "dices" || menuViewMode == "life"? 0:maxSize:40,
                    width: centerButtonClicked?
                    menuViewMode == "dices" || menuViewMode == "life"? 0:maxSize:40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: centerButtonClicked?Colors.white38:Colors.black38,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: centerButtonClicked?3:0,
                        ),
                        BoxShadow(
                            color: centerButtonClicked?Colors.white:Colors.black,
                            blurRadius: 1.1
                        ),
                      ],
                    ),
                    child: GestureDetector(
                        onTap: (){
                          setState(() {
                            if(widget.playersInfo["activeTemp"].every((element) => element == false)){
                              centerButtonClicked = centerButtonClicked? false:true;
                              menuViewMode = "main";
                            }
                          });
                        },
                        child: LayoutBuilder(
                          builder: (context,constraints){
                            return Icon(
                              MdiIcons.cubeOutline,
                              color: centerButtonClicked?Colors.black:Colors.white,
                              size: constraints.maxWidth* (centerButtonClicked? 0.8:0.75),
                            );
                          },
                        )
                    )
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: RotatedBox(
          quarterTurns: heightBiggerThanWidth()? 0:3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildLifepadMatt(),
              RawMaterialButton(
                constraints: centerButtonClicked || !widget.isPlaying?
                BoxConstraints.expand() :
                BoxConstraints.expand(width: 0,height: 0),
                onPressed: (){
                  if(widget.isPlaying){
                    setState(() {
                      centerButtonClicked = false;
                      menuViewMode = "main";
                    });
                  } else {
                    setState(() => play = true);
                    Navigator.pop(context);
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  color: widget.isPlaying? Colors.black54:Colors.transparent,
                ),
              ),
              centerButton()
            ],
          ),
        ),
      ),
    );
  }
}
