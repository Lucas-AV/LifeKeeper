import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'lifepad.dart';


List countersList = ['infect','energy','experience','treasure','cmd. tax'];
bool play = true;

Map dicesMap = {
  "normal":{
    4:MdiIcons.diceD4,
    6:MdiIcons.diceD6,
    8:MdiIcons.diceD8,
    10:MdiIcons.diceD10,
    12:MdiIcons.diceD12,
    20:MdiIcons.diceD20,
  },
  "outlined":{
    4:MdiIcons.diceD4Outline,
    6:MdiIcons.diceD6Outline,
    8:MdiIcons.diceD8Outline,
    10:MdiIcons.diceD10Outline,
    12:MdiIcons.diceD12Outline,
    20:MdiIcons.diceD20Outline,
  }
};

List dicesValues = [4,6,8,10,12,20];

List<Color> colorsList = [
  const Color(0xffB22222),
  const Color(0xff1E8449),
  const Color(0xff355691),
  const Color(0xff101214),

  Colors.deepOrange,
  Colors.pink,
  Colors.white,
  Color.fromRGBO(110,142,36,1),

  Colors.purple,
  Color.fromRGBO(0,112,88,1),
  Color.fromRGBO(146,73,39,1),
  const Color(0xff484743),

  Colors.teal,
  const Color(0xff16425B),
  Colors.pinkAccent,
  Colors.deepPurple,
];

Map<String, Color> colorMap = {
  "NULL":Colors.transparent,
  "Apple Green - Matte Sleeves": const Color.fromRGBO(0,158,75,1),
  "Ruby - Matte Sleeves": const Color.fromRGBO(165,25,31,1),
  "Black - Matte Sleeves": const Color.fromRGBO(25,21,22,1),
  "Sapphire - Matte Sleeves": const Color.fromRGBO(11,135,192,1),
  "Glacier - Matte Dual Sleeves": const Color.fromRGBO(0,158,170,1),
  "Magenta - Matte Sleeves": const Color.fromRGBO(175,27,86,1),
  "Orange - Matte Sleeves": const Color.fromRGBO(248,154,0,1),
  "Brown - Classic Sleeves": const Color.fromRGBO(80,37,16,1),
  "Copper - Classic Sleeves": const Color.fromRGBO(146,73,39,1),
  "Copper - Matte Sleeves": const Color.fromRGBO(176,87,59,1),
  "Crimson - Matte Sleeves": const Color.fromRGBO(190,9,23,1),
  "Crypt - Matte Dual Sleeves": const Color.fromRGBO(132,126,115,1),
  "Ember - Dual Matte Sleeves": const Color.fromRGBO(215,74,40,1),
  "Emerald - Matte Sleeves": const Color.fromRGBO(4,85,40,1),
  "Eucalyptus - Matte Dual Sleeves": const Color.fromRGBO(167,213,189,1),
  "Forest Green - Matte Sleeves": const Color.fromRGBO(65,94,65,1),
  "Gold - Classic Sleeves": const Color.fromRGBO(148,98,38,1),
  "Gold - Matte Sleeves": const Color.fromRGBO(166,97,17,1),
  "Green - Classic Sleeves": const Color.fromRGBO(0,112,88,1),
  "Green - Matte Sleeves": const Color.fromRGBO(0,89,53,1),
  "Ivory - Matte Sleeves": const Color.fromRGBO(228,220,193,1),
  "Jet - Matte Sleeves": const Color.fromRGBO(32,27,26,1),
  "Lagoon - Matte Dual Sleeves": const Color.fromRGBO(87,138,174,1),
  "Lime - Matte Sleeves": const Color.fromRGBO(154,184,85,1),
  "Midnight Blue - Matte Sleeves": const Color.fromRGBO(0,35,67,1),
  "Might - Dual Matte Sleeves": const Color.fromRGBO(0,102,60,1),
  "Mint - Classic Sleeves": const Color.fromRGBO(81,179,154,1),
  "Mint - Matte Sleeves": const Color.fromRGBO(0,192,157,1),
  "Nebula - Matte Sleeves": const Color.fromRGBO(125,105,178,1),
  "Night Blue - Classic Sleeves": const Color.fromRGBO(19,20,68,1),
  "Night Blue - Matte Sleeves": const Color.fromRGBO(15,14,58,1),
  "Olive - Matte Sleeves": const Color.fromRGBO(110,142,36,1),
  "Orchid - Matte Dual Sleeves": const Color.fromRGBO(187,168,197,1),
  "Peach - Matte Dual Sleeves": const Color.fromRGBO(244,133,127,1),
  "Petrol - Matte Sleeves": const Color.fromRGBO(0,89,100,1),
  "Pink - Matte Sleeves": const Color.fromRGBO(238,150,169,1),
  "Pink Diamond - Matte Sleeves": const Color.fromRGBO(226,111,169,1),
  "Purple - Classic Sleeves": const Color.fromRGBO(68,50,95,1),
  "Purple - Matte Sleeves": const Color.fromRGBO(66,47,94,1),
  "Silver - Classic Sleeves": const Color.fromRGBO(137,138,138,1),
  "Silver - Matte Sleeves": const Color.fromRGBO(161,157,154,1),
  "Sky Blue - Matte Sleeves": const Color.fromRGBO(0,123,169,1),
  "Slate - Matte Sleeves": const Color.fromRGBO(47,43,44,1),
  "Snow - Matte Dual Sleeves": const Color.fromRGBO(252,251,251,1),
  "Tangerine - Classic Sleeves": const Color.fromRGBO(232,79,14,1),
  "Turquoise - Players' Choice Matte Sleeves": const Color.fromRGBO(0,149,173,1),
  "Valor - Dual Matte Sleeves": const Color.fromRGBO(254,245,217,1),
  "White - Classic Sleeves": const Color.fromRGBO(224,224,224,1),
  "White - Matte Sleeves": const Color.fromRGBO(220,222,220,1),
  "Wisdom - Dual Matte Sleeves": const Color.fromRGBO(0,77,155,1),
  "Yellow - Matte Sleeves": const Color.fromRGBO(236,198,0,1),
};

Map originalColors = {
  "NULL":Colors.transparent,
  "Apple Green - Matte Sleeves": const Color.fromRGBO(0,158,75,1),
  "Blood Red - Matte Sleeves": const Color.fromRGBO(133,36,53,1),
  "Black - Classic Sleeves": const Color.fromRGBO(32,27,27,1),
  "Black - Matte Sleeves": const Color.fromRGBO(25,21,22,1),
  "Blue - Classic Sleeves": const Color.fromRGBO(4,90,134,1),
  "Blue - Matte Sleeves": const Color.fromRGBO(0,57,118,1),
  "Brown - Classic Sleeves": const Color.fromRGBO(80,37,16,1),
  "Copper - Classic Sleeves": const Color.fromRGBO(146,73,39,1),
  "Copper - Matte Sleeves": const Color.fromRGBO(176,87,59,1),
  "Crimson - Classic Sleeves": const Color.fromRGBO(185,32,24,1),
  "Crimson - Matte Sleeves": const Color.fromRGBO(190,9,23,1),
  "Crypt - Matte Dual Sleeves": const Color.fromRGBO(132,126,115,1),
  "Ember - Dual Matte Sleeves": const Color.fromRGBO(215,74,40,1),
  "Emerald - Matte Sleeves": const Color.fromRGBO(4,85,40,1),
  "Eucalyptus - Matte Dual Sleeves": const Color.fromRGBO(167,213,189,1),
  "Forest Green - Matte Sleeves": const Color.fromRGBO(65,94,65,1),
  "Fury - Dual Matte Sleeves": const Color.fromRGBO(203,0,67,1),
  "Glacier - Matte Dual Sleeves": const Color.fromRGBO(0,158,170,1),
  "Gold - Classic Sleeves": const Color.fromRGBO(148,98,38,1),
  "Gold - Matte Sleeves": const Color.fromRGBO(166,97,17,1),
  "Green - Classic Sleeves": const Color.fromRGBO(0,112,88,1),
  "Green - Matte Sleeves": const Color.fromRGBO(0,89,53,1),
  "Ivory - Matte Sleeves": const Color.fromRGBO(228,220,193,1),
  "Jet - Matte Sleeves": const Color.fromRGBO(32,27,26,1),
  "Lagoon - Matte Dual Sleeves": const Color.fromRGBO(87,138,174,1),
  "Lightning - Matte Dual Sleeves": const Color.fromRGBO(234,220,69,1),
  "Lime - Matte Sleeves": const Color.fromRGBO(154,184,85,1),
  "Magenta - Matte Sleeves": const Color.fromRGBO(175,27,86,1),
  "Midnight Blue - Matte Sleeves": const Color.fromRGBO(0,35,67,1),
  "Might - Dual Matte Sleeves": const Color.fromRGBO(0,102,60,1),
  "Mint - Classic Sleeves": const Color.fromRGBO(81,179,154,1),
  "Mint - Matte Sleeves": const Color.fromRGBO(0,192,157,1),
  "Nebula - Matte Sleeves": const Color.fromRGBO(125,105,178,1),
  "Night Blue - Classic Sleeves": const Color.fromRGBO(19,20,68,1),
  "Night Blue - Matte Sleeves": const Color.fromRGBO(15,14,58,1),
  "Olive - Matte Sleeves": const Color.fromRGBO(110,142,36,1),
  "Orange - Matte Sleeves": const Color.fromRGBO(248,154,0,1),
  "Orchid - Matte Dual Sleeves": const Color.fromRGBO(187,168,197,1),
  "Peach - Matte Dual Sleeves": const Color.fromRGBO(244,133,127,1),
  "Petrol - Matte Sleeves": const Color.fromRGBO(0,89,100,1),
  "Pink - Matte Sleeves": const Color.fromRGBO(238,150,169,1),
  "Pink Diamond - Matte Sleeves": const Color.fromRGBO(226,111,169,1),
  "Purple - Classic Sleeves": const Color.fromRGBO(68,50,95,1),
  "Purple - Matte Sleeves": const Color.fromRGBO(66,47,94,1),
  "Red - Matte Sleeves": const Color.fromRGBO(159,32,43,1),
  "Ruby - Matte Sleeves": const Color.fromRGBO(165,25,31,1),
  "Sapphire - Matte Sleeves": const Color.fromRGBO(11,135,192,1),
  "Silver - Classic Sleeves": const Color.fromRGBO(137,138,138,1),
  "Silver - Matte Sleeves": const Color.fromRGBO(161,157,154,1),
  "Sky Blue - Matte Sleeves": const Color.fromRGBO(0,123,169,1),
  "Slate - Matte Sleeves": const Color.fromRGBO(47,43,44,1),
  "Snow - Matte Dual Sleeves": const Color.fromRGBO(252,251,251,1),
  "Tangerine - Classic Sleeves": const Color.fromRGBO(232,79,14,1),
  "Tangerine - Matte Sleeves": const Color.fromRGBO(233,79,13,1),
  "Turquoise - Players' Choice Matte Sleeves": const Color.fromRGBO(0,149,173,1),
  "Valor - Dual Matte Sleeves": const Color.fromRGBO(254,245,217,1),
  "White - Classic Sleeves": const Color.fromRGBO(224,224,224,1),
  "White - Matte Sleeves": const Color.fromRGBO(220,222,220,1),
  "Wisdom - Dual Matte Sleeves": const Color.fromRGBO(0,77,155,1),
  "Wraith - Dual Matte Sleeves": const Color.fromRGBO(124,34,87,1),
  "Yellow - Matte Sleeves": const Color.fromRGBO(236,198,0,1),
};

BoxDecoration lifepadBoxDecoration(Color color){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: color.withOpacity(0.5),
    boxShadow: [
      BoxShadow(
        color: color,
        blurRadius: 1
      )
    ],
  );
}

TextStyle boldTextStyle({Color color = Colors.white}){
  return TextStyle(
    fontWeight: FontWeight.bold,
    color: color,
    shadows: [
      Shadow(
        color: color,
        blurRadius: 1,
      )
    ],
  );
}

BoxConstraints infinityBoxConstraints(){
  return BoxConstraints.expand(width: double.infinity,height: double.infinity);
}

EdgeInsets lifepadPadding(LifePad widget){
  return EdgeInsets.only(
    right: (
      widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0 ||
      widget.numberOfPlayers % 2 != 0 && widget.id < widget.numberOfPlayers?
      5:8
    ),
    left: (
      widget.numberOfPlayers > 2 && widget.numberOfPlayers % 2 == 0 ||
      widget.numberOfPlayers % 2 != 0 && widget.id < widget.numberOfPlayers?
      5:8
    ),
    bottom: 8,
    top: 5
  );
}

Widget lifepadButton(
  Function onPressed,
{
  IconData icon = MdiIcons.cardsOutline,
  Color iconColor = Colors.white,
  double multi = .7,
  double height = 60,
  double width = 60,
  bool hasSecond = false,
}){
  void voidOnPressed(){
    onPressed();
  }
  return Container(
    constraints: BoxConstraints(maxWidth: width,maxHeight: height,minWidth: 0,minHeight: 0),
    child: RawMaterialButton(
      constraints: BoxConstraints(minWidth: 0,minHeight: 0),
      onPressed: voidOnPressed,
      child: LayoutBuilder(
        builder: (context,constraints){
          return Icon(
            icon,
            color: iconColor,
            size: constraints.maxWidth*multi,
          );
        },
      ),
    ),
  );
}

Widget lifepadButtonOpacity(
    Function onPressed,
    {
      bool condition = true,
      IconData icon = MdiIcons.cardsOutline,
      Color iconColor = Colors.white,
      double multi = .7,
      double height = 60,
      double width = 60,
      bool hasSecond = false,
    }) {
  void voidOnPressed(){
    onPressed();
  }

  Widget body(){
    return LayoutBuilder(
      builder: (context,constraints){
        return AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: condition? 1:0,
          child: Icon(
            icon,
            color: iconColor,
            size: constraints.maxWidth*multi,
          ),
        );
      },
    );
  }

  return Container(
    constraints: BoxConstraints(maxHeight: height,maxWidth: width,minWidth: 0,minHeight: 0),
    child: condition? RawMaterialButton(
      constraints: BoxConstraints(minWidth: 0,minHeight: 0),
      onPressed: voidOnPressed,
      child: body(),
    ) : SizedBox(),
  );
}


Widget lifepadButtonOpacityDouble(
    Function onPressed,
    {
      bool condition = true,
      IconData initialIcon = MdiIcons.cardsOutline,
      IconData afterIcon = MdiIcons.cards,
      Color iconColor = Colors.white,
      double multi = .7,
      double height = 60,
      double width = 60,
      bool hasSecond = false,
    }){
  void voidOnPressed(){
    onPressed();
  }
  return Container(
    constraints: BoxConstraints(maxWidth: height,maxHeight: width,minWidth: 0,minHeight: 0),
    child: RawMaterialButton(
      constraints: BoxConstraints(minWidth: 0,minHeight: 0),
      onPressed: voidOnPressed,
      child: LayoutBuilder(
        builder: (context,constraints){
          return Stack(
            children: [
              Icon(
                initialIcon,
                color: iconColor,
                size: constraints.maxWidth*multi,
              ),
              AnimatedOpacity(
                opacity: condition? 1:0,
                duration: Duration(milliseconds: 150),
                child: Icon(
                  afterIcon,
                  color: iconColor,
                  size: constraints.maxWidth*multi,
                ),
              )
            ],
          );
        },
      ),
    ),
  );
}



Widget lifepadButtonOpacityDoubleChange(
    Function onPressed,
    {
      bool condition = true,
      IconData initialIcon = MdiIcons.cardsOutline,
      IconData afterIcon = MdiIcons.cards,
      Color iconColor = Colors.white,
      double multi = .7,
      double height = 60,
      double width = 60,
      bool hasSecond = false,
    })
{
  void voidOnPressed(){
    onPressed();
  }
  return Container(
    constraints: BoxConstraints(maxWidth: height,maxHeight: width),
    child: RawMaterialButton(
      constraints: BoxConstraints(minWidth: 0,minHeight: 0),
      onPressed: voidOnPressed,
      child: LayoutBuilder(
        builder: (context,constraints){
          return Stack(
            children: [
              AnimatedOpacity(
                opacity: condition? 0:1,
                duration: Duration(milliseconds: 150),
                child: Icon(
                  initialIcon,
                  color: iconColor,
                  size: constraints.maxWidth*multi,
                ),
              ),
              AnimatedOpacity(
                opacity: condition? 1:0,
                duration: Duration(milliseconds: 150),
                child: Icon(
                  afterIcon,
                  color: iconColor,
                  size: constraints.maxWidth*multi,
                ),
              )
            ],
          );
        },
      ),
    ),
  );
}



Widget highlightContainer({
  Widget child = const SizedBox(),
  Color color = Colors.black38,
  bool condition = false,
  double borderRadius = 5,
}){
  return Stack(
    alignment: Alignment.center,
    children: [
      AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: condition? 1:0,
        child: Container(
          decoration: BoxDecoration(
            color: condition? color:Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          child: Opacity(
            opacity: 0,
            child: child,
          ),
        ),
      ),
      child,
    ],
  );
}

class PositionedButton extends StatelessWidget {
  PositionedButton({
    Key? key,
    this.initialIcon = MdiIcons.cardsOutline,
    this.afterIcon = MdiIcons.cards,
    this.initialMode = "minimalist",
    this.visibleCondition = true,
    this.afterMode = "detailed",
    this.color = Colors.white,
    required this.onPressed,
    this.condition = true,
    this.multi = .7,
  }) : super(key: key);
  bool visibleCondition;
  IconData initialIcon;
  Function onPressed;
  IconData afterIcon;
  String initialMode;
  String afterMode;
  // String position;
  bool condition;
  double multi;
  Color color;

  @override
  Widget build(BuildContext context) {
    Widget child = lifepadButtonOpacityDoubleChange(
      onPressed,
      initialIcon: initialIcon,
      afterIcon: afterIcon,
      condition: condition,
      iconColor: color,
      multi: multi
    );

    return Visibility(
      visible: visibleCondition,
      child: child,
    );
  }
}

class ButtonRow extends StatelessWidget {
  ButtonRow({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.end,
    required this.leftButton,
    required this.rightButton,
  }) : super(key: key);
  MainAxisAlignment mainAxisAlignment;
  Widget rightButton;
  Widget leftButton;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Row(
          children: [
            leftButton,
            Expanded(child: SizedBox()),
            rightButton,
          ],
        ),
      ],
    );
  }
}

class LifepadSection extends StatefulWidget {
  LifepadSection({
    Key? key,
    this.title = "ROLL A DICE",
    this.crossAxisCount = 4,
    this.color = Colors.red,
    this.visible = false,
    required this.onRandom,
    required this.children,
    required this.onClose,
  }) : super(key: key);
  List<Widget> children;
  int crossAxisCount;
  Function onRandom;
  Function onClose;
  bool visible;
  String title;
  Color color;

  @override
  State<LifepadSection> createState() => _LifepadSectionState();
}

class _LifepadSectionState extends State<LifepadSection> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        decoration: lifepadBoxDecoration(widget.color),
        child: Column(
          children: [
            Container(
                constraints: BoxConstraints(
                  maxHeight: 60,
                  maxWidth: double.infinity,
                ),
                color: widget.color == Colors.white? Colors.black12:Colors.black26,
                child: LayoutBuilder(
                  builder: (context,constraints){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            SizedBox(width: 5),
                            lifepadButton(
                              (){
                                widget.onClose();
                              },
                              iconColor: widget.color == Colors.white? Colors.black:Colors.white,
                              icon: Icons.close,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                            child: FittedBox(
                              child: Text(
                                widget.title,
                                style: boldTextStyle(
                                  color: widget.color == Colors.white? Colors.black:Colors.white,
                                )
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            lifepadButton(
                              (){
                                widget.onRandom();
                              },
                              icon: widget.title != "CHOOSE A COLOR" && widget.title != "ROLL A DICE"?
                              MdiIcons.refresh:Icons.question_mark,
                              iconColor: widget.color == Colors.white? Colors.black:Colors.white,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ],
                    );
                  },
                )
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: widget.crossAxisCount,
                children: widget.children,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResponsiveIcon extends StatelessWidget {
  const ResponsiveIcon({Key? key, required this.icon, this.multi = 1, this.color = Colors.white}) : super(key: key);
  final Color color;
  final double multi;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Icon(
            icon,
            color: color,
            size: constraints.biggest.shortestSide * multi
        );
      },
    );
  }
}

class CenterMenuIconButton extends StatelessWidget {
  CenterMenuIconButton({Key? key, required this.icon, required this.onPressed,this.multi = 1, this.color = Colors.white, this.height = 2.5}) : super(key: key);
  final Color color;
  final double multi;
  final IconData icon;
  final double height;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: RawMaterialButton(
          onPressed: (){
            onPressed();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height),
            child: ResponsiveIcon(
              multi: multi,
              color: color,
              icon: icon,
            ),
          ),
        ),
      ),
    );
  }
}