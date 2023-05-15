import 'package:flutter/material.dart';
import 'package:lifekeeper/style.dart';
import 'main_page.dart';
import 'dart:async';
import 'main.dart';
import 'dart:math';

class LifePad extends StatefulWidget {
  LifePad({Key? key, required this.color,this.quarterTurns = 0, this.base = 40, required this.id, required this.numberOfPlayers}) : super(key: key);
  final int numberOfPlayers;
  final int quarterTurns;
  final Color color;
  final int base;
  final int id;
  @override
  State<LifePad> createState() => _LifePadState();
}

class _LifePadState extends State<LifePad> {
  Timer timeCounter = Timer(Duration(seconds: 0),(){});
  int value = 1;

  @override
  void initState(){
    super.initState();
    value = widget.base;
  }

  Widget counterValueText() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 150,
        minWidth: 150,
        // minWidth: double.infinity
      ),
      child: FittedBox(
        child: Text(
          value.toString(),
          style: boldTextStyle(),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget counterModifierButton({int num = 1}){
    void onPressed(){
      setState(() {
        value += num;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
