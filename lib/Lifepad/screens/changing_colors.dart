import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/components/lifepad_icon_button.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';
import 'package:lifekeeper/Lifepad/style/lifepad_screen_decoration.dart';

class ChangingColors extends StatefulWidget {
  const ChangingColors({super.key, required this.isCurrent, required this.lifepadModel, required this.constraints, required this.onChangingColor});
  final bool isCurrent;
  final LifepadModel lifepadModel;
  final BoxConstraints constraints;
  final Function() onChangingColor;

  @override
  State<ChangingColors> createState() => _ChangingColorsState();
}

class _ChangingColorsState extends State<ChangingColors> {
  @override
  Widget build(BuildContext context) {
    if (widget.isCurrent == false) return SizedBox();
    
    return Container(
      decoration: lifepadScreenDecoration(widget.lifepadModel),
      alignment: Alignment.center,
      child: Stack(children: [
        LifepadIconButton(
          alignment: Alignment.topLeft,
          constraints: widget.constraints,
          iconData: Icons.arrow_circle_left_outlined,
          onPressed: () => widget.onChangingColor(),
        ),
      ]),
    );
  }
}
