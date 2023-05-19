import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'lifepad.dart';
import 'dart:async';

class CenterButton extends StatelessWidget {
  const CenterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class MainPage extends StatefulWidget {
  MainPage({Key? key, this.numberOfPlayers = 2, this.base = 40, this.passiveColors = const []}) : super(key: key);
  int numberOfPlayers;
  int base;
  List passiveColors;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String menuViewMode = "main";
  bool centerButtonClicked = false;
  double maxSize = 80;
  List<Widget> children = [];
  late Map playersInfo;
  int maxPlayers = 7;
  void changeViewMode(String newMode){
    setState(() {
      menuViewMode = newMode;
    });
  }

  @override
  void initState(){
    super.initState();
     setState(() {

       playersInfo = {
         "colors":widget.passiveColors.isNotEmpty? widget.passiveColors : List.generate(maxPlayers+1, (index) => colorsList[index]),
         "commander":List.generate(maxPlayers+1, (index) => List.generate(widget.numberOfPlayers, (subIndex) => 0)),
         "initiative":List.generate(maxPlayers+1, (index) => false),
         "life":List.generate(maxPlayers+1, (index) => widget.base),
         "attacking":List.generate(maxPlayers+1, (index) => false),
         "ascended":List.generate(maxPlayers+1, (index) => false),
         "monarch":List.generate(maxPlayers+1, (index) => false),
         "numberOfPlayers":widget.numberOfPlayers,
         "base":widget.base,
       };
     });
  }

  @override
  Widget build(BuildContext context) {

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
                      color: playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: playersInfo,
                    )
                ],
              ) :
              Row(
                children: [
                  for(int j = 0; j < 2; j++)
                    LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: playersInfo,
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
                      color: playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: playersInfo,
                    )
                ],
              ) :
                Row(
                  children: [
                    for(int j = 0; j < 2; j++)
                      LifePad(
                      quarterTurns: (maxHei >= maxWid)? (j == 0? 1:3):(j == 0? 3:1),
                      numberOfPlayers: widget.numberOfPlayers,
                      color: playersInfo['colors'][j + i * 2 + 1-1],
                      id: j + i * 2 + 1,
                      base: widget.base,
                      playersInfo: playersInfo,
                      )
                  ],
                ),
            ),
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)?0:3,
            color: playersInfo['colors'][widget.numberOfPlayers-1],
            id: widget.numberOfPlayers,
            base: widget.base,
            playersInfo: playersInfo,
          )
        ];
      }

      return [
        for(int i = 1; i < widget.numberOfPlayers+1; i++)
          LifePad(
            numberOfPlayers: widget.numberOfPlayers,
            quarterTurns: (maxHei >= maxWid)? (i == 1? 2:0):(i == 1? 1:3),
            color: playersInfo['colors'][i-1],
            id: i,
            base: widget.base,
            playersInfo: playersInfo,
          )
      ];
    }

    void resetPage(){
      setState(() {
        centerButtonClicked = false;
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            numberOfPlayers: widget.numberOfPlayers,
            base: widget.base,
            passiveColors: playersInfo["colors"],
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

    Widget centerButton(){
      return Stack(
        alignment: Alignment.center,
        children: [
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
          RotatedBox(
            quarterTurns: (maxHei >= maxWid)? 0:3,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: centerButtonClicked? maxSize:40,
                width: centerButtonClicked? maxSize:40,
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
                        centerButtonClicked = centerButtonClicked? false:true;
                        menuViewMode = "main";
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
              ),
              widget.numberOfPlayers % 4 == 0 || widget.numberOfPlayers < 5? centerButton() :
              (maxHei >= maxWid)?
              Column(
                children: [
                  Expanded(
                    flex: 14,
                    child: SizedBox(),
                  ),
                  centerButton(),
                  Expanded(
                    flex: 7,
                    child: SizedBox(),
                  )
                ],
              ) :
              Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: SizedBox(),
                  ),
                  centerButton(),
                  Expanded(
                    flex: 7,
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
