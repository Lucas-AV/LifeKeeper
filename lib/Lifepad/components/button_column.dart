import 'dart:async';
import 'package:flutter/material.dart';

class ButtonColumn extends StatefulWidget {
  const ButtonColumn({super.key, required this.onPressed});
  final Function(int index) onPressed;
  @override
  State<ButtonColumn> createState() => _ButtonColumnState();
}

class _ButtonColumnState extends State<ButtonColumn> {
  Timer onPressedTimer = Timer(Duration(microseconds: 0), (){});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (int i = 0; i < 2; i++)
        Expanded(
          child: GestureDetector(
            onLongPressEnd: (d){
              onPressedTimer.cancel();
            },
            onLongPress: () {
              if (onPressedTimer.isActive) onPressedTimer.cancel();
              onPressedTimer = Timer.periodic(Duration(milliseconds: 100), (timer) => widget.onPressed(i));
            },
            child: RawMaterialButton(
              onPressed: () => widget.onPressed(i),
              child: Container(),
            ),
          ),
        )
    ]);
  }
}