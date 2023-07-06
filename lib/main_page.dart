
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'lifepad.dart';
import 'style.dart';
import 'dart:async';
import 'dart:math';

class CenterButton extends StatelessWidget {
  const CenterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


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
    for(int i = 0; i < 50; i++){
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
                      color: widget.playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: widget.playersInfo,
                      isPlaying: widget.isPlaying,
                    )
                ],
              ) :
              Row(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: widget.playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: widget.playersInfo,
                      isPlaying: widget.isPlaying,
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
                      color: widget.playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: widget.playersInfo,
                      isPlaying: widget.isPlaying,
                    )
                ],
              ) :
                Row(
                  children: [
                    for(int j = 0; j < 2; j++)
                      LifePad(
                        quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                        numberOfPlayers: widget.numberOfPlayers,
                        color: widget.playersInfo['colors'][j + i * 2 + 1-1],
                        id: j + i * 2 + 1,
                        base: widget.base,
                        playersInfo: widget.playersInfo,
                        isPlaying: widget.isPlaying,
                      )
                  ],
                ),
            ),
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)?0:3,
            color: widget.playersInfo['colors'][widget.numberOfPlayers-1],
            id: widget.numberOfPlayers,
            base: widget.base,
            playersInfo: widget.playersInfo,
            isPlaying: widget.isPlaying,
          )
        ];
      }

      return [
        for(int i = 1; i < widget.numberOfPlayers+1; i++)
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)? (i == 1? 2:0):(i == 1? 1:3),
            color: widget.playersInfo['colors'][i-1],
            id: i,
            base: widget.base,
            playersInfo: widget.playersInfo,
            isPlaying: widget.isPlaying,
          )
      ];
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
          children: [
            for(int i = 0; i < 2; i++)
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    height: 15,
                    width: 30,
                  ),
                  SizedBox(height: i != 1 ? 2 : 0),
                ],
              )
          ],
        ),
        3: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < 2; i++)
                  Row(children: [
                    Container(
                      color: Colors.black,
                      height: 15,
                      width: 14,
                    ),
                    SizedBox(width: i != 1 ? 2 : 0),
                  ],
                  )
              ],
            ),
            const SizedBox(height: 2),
            Container(
              color: Colors.black,
              height: 15,
              width: 30,
            ),
          ],
        ),
        4: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(int i = 0; i < 2; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 14,
                        width: 15,
                      ),
                      const SizedBox(width: 2),
                      Container(
                        color: Colors.black,
                        height: 14,
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(height: i != 2 ? 2 : 0),
                ],
              )
          ],
        ),
        5: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(int i = 0; i < 2; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 18 / 2,
                        width: 14,
                      ),
                      const SizedBox(width: 2),
                      Container(
                        color: Colors.black,
                        height: 18 / 2,
                        width: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            Container(
              color: Colors.black,
              height: 18 / 2,
              width: 30,
            ),
          ],
        ),
        6: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(int i = 0; i < 3; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 18 / 2,
                        width: 14,
                      ),
                      const SizedBox(width: 2),
                      Container(
                        color: Colors.black,
                        height: 18 / 2,
                        width: 14,
                      ),
                    ],
                  ),
                  SizedBox(height: i != 2 ? 2 : 0),
                ],
              )
          ],
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
              fontSize: maxWid * 0.06,
            )
          ),
        ),
      );
    }

    Widget centerButton(){
      return SizedBox(
        height: maxSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // MAIN
            RotatedBox(
              quarterTurns: (maxHei >= maxWid)?0:3,
              child: AnimatedContainer(
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
                              onPressed: (){
                                resetPage();
                              },
                              icon: MdiIcons.refresh,
                              color: Colors.black,
                            ),
                            CenterMenuIconButton(
                              onPressed: (){
                                changeViewMode("players");
                              },
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
                              onPressed: (){
                                changeViewMode("life");
                              },
                              icon: MdiIcons.heartCog,
                              color: Colors.black,
                            ),
                            CenterMenuIconButton(
                              onPressed: (){
                                changeViewMode("dices");
                              },
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
            ),

            // PLAYERS
            RotatedBox(
              quarterTurns: (maxHei >= maxWid)?0:3,
              child: AnimatedContainer(
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
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CenterMenuIconButton(
                            onPressed: (){
                              setState(() {
                                menuViewMode = "menu";
                              });
                            },
                            icon: MdiIcons.arrowLeftBold,
                            color: Colors.black,
                          ),
                          swapPlayerNum(2),
                          swapPlayerNum(3),
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
                          swapPlayerNum(4),
                          swapPlayerNum(5),
                          swapPlayerNum(6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DICES
            RotatedBox(
              quarterTurns: (maxHei >= maxWid)?0:3,
              child: AnimatedContainer(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CenterMenuIconButton(
                            onPressed: (){
                              setState(() {
                                menuViewMode = "menu";
                              });
                            },
                            icon: MdiIcons.arrowLeftBold,
                            color: Colors.black,
                          ),
                          chooseDiceToRoll(4),
                          chooseDiceToRoll(6),
                          chooseDiceToRoll(8),
                          chooseDiceToRoll(10),
                          chooseDiceToRoll(12),
                          chooseDiceToRoll(20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LIFE
            RotatedBox(
              quarterTurns: (maxHei >= maxWid)?0:3,
              child: AnimatedContainer(
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
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CenterMenuIconButton(
                            onPressed: (){
                              setState(() {
                                menuViewMode = "menu";
                              });
                            },
                            icon: MdiIcons.arrowLeftBold,
                            color: Colors.black,
                          ),
                          swapLife(20),
                          swapLife(30),
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
                          swapLife(40),
                          swapLife(50),
                          swapLife(60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Stack(
              alignment: Alignment.center,
              children: [
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
            RotatedBox(
              quarterTurns: (maxHei >= maxWid)? 0:3,
              child: AnimatedContainer(
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
                          // widget.numberOfPlayers++;
                          // if(widget.numberOfPlayers > 6){
                          //   widget.numberOfPlayers = 2;
                          // }
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
            ),
          ],
        ),
      );
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
              widget.isPlaying?
                Visibility(
                visible: centerButtonClicked,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      centerButtonClicked = false;
                      menuViewMode = "main";
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black54,
                  ),
                ),
              ) :
                RawMaterialButton(
                  onPressed: (){
                    setState(() {
                      play = true;
                    });
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),

              if(widget.isPlaying)
                widget.numberOfPlayers % 4 == 0 || widget.numberOfPlayers < 5? centerButton() :
                (maxHei >= maxWid)?
                Column(
                  children: [
                    Expanded(
                      flex: 13,
                      child: SizedBox(),
                    ),
                    centerButton(),
                    Expanded(
                      flex: 6,
                      child: SizedBox(),
                    )
                  ],
                ) :
                Row(
                  children: [
                    Expanded(
                      flex: 13,
                      child: SizedBox(),
                    ),
                    centerButton(),
                    Expanded(
                      flex: 6,
                      child: SizedBox(),
                    )
                  ],
                )
            ],
          )
        ),
      ),
    );
  }
}
