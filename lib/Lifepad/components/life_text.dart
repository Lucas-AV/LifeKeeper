import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';

class LifeText extends StatefulWidget {
  const LifeText({super.key, required this.lifepadModel});
  final LifepadModel lifepadModel;

  @override
  State<LifeText> createState() => _LifeTextState();
}

class _LifeTextState extends State<LifeText> {
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: constraints.maxHeight * 0.5,
        width: double.infinity,
        child: FittedBox(
          child: Text(
            widget.lifepadModel.counters[widget.lifepadModel.currentTypeOfCounter].toString(),
            style: TextStyle(
              color: widget.lifepadModel.fontColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
