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
  final Color color;
  bool isAttacking;
  final int base;
  final int id;
  int value;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  Timer timeCounter = Timer(Duration(seconds: 0),(){});
  int viewMode = 0, limit = 1;
  @override
  void initState(){
    super.initState();
  }

  Widget counterValueText() {
    return LayoutBuilder(
      builder: (context,constraints){
        return AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: (constraints.maxWidth > constraints.maxHeight? constraints.maxWidth : constraints.maxHeight) * (
             viewMode == 0? 0.35 : 0.35
          ),
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

  Widget counterModifierButton({int num = 1}){
    void onPressed(){
      setState(() {
        widget.value += num;
      });
    }

    void onLongPress(){
      timeCounter = Timer.periodic(
          const Duration(milliseconds: 100),
          (timer) {
            onPressed();
          }
      );
    }

    void onLongEnd(LongPressEndDetails details) {
      timeCounter.cancel();
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
    return Column(
      children: [
        counterModifierButton(num: 1),
        counterModifierButton(num: -1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardsOutlinedButton(){
      return Positioned(
        right: 0,
        top: 0,
        child: lifepadButtonOpacityDouble(
          (){
            setState(() {
              viewMode++;
              if(viewMode > limit){
                viewMode = 0;
              }
            });
          },
          condition: viewMode == 1
        ),
      );
    }

    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: Padding(
          padding: lifepadPadding(widget),
          child: Container(
            decoration: lifepadBoxDecoration(widget.color),
            child: Stack(
              alignment: Alignment.center,
              children: [
                counterValueText(),
                modifierColumn(),
                cardsOutlinedButton(),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: lifepadButtonOpacity(
                    (){},
                    icon: MdiIcons.paletteOutline,
                    condition: viewMode == 1
                  ),
                ),

                if(false)
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: highlightContainer(
                    child: lifepadButtonOpacity(
                      (){
                        setState(() {
                          widget.isAttacking = widget.isAttacking? false:true;
                        });
                      },
                      icon: MdiIcons.swordCross,
                      condition: viewMode == 0,
                      multi: 0.575
                    ),
                    borderRadius: 0,
                    condition: widget.isAttacking,
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: lifepadButtonOpacity(
                    (){},
                    icon: MdiIcons.diceMultipleOutline,
                    condition: viewMode == 1
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

