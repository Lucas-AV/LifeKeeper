import 'package:lifekeeper/Lifepad/lifepad_model.dart';
import 'package:lifekeeper/Old/style.dart';
import 'package:lifekeeper/universal.dart' as universal;
import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/components/lifepad_icon_button.dart';

class ChaningCounterScreen extends StatefulWidget {
  const ChaningCounterScreen(
      {super.key,
      required this.lifepadModel,
      required this.constraints,
      required this.isChangingCounter,
      required this.onChangingCounter});
  final LifepadModel lifepadModel;
  final BoxConstraints constraints;
  final bool isChangingCounter;
  final Function(String) onChangingCounter;
  @override
  State<ChaningCounterScreen> createState() => _ChaningCounterScreenState();
}

class _ChaningCounterScreenState extends State<ChaningCounterScreen> {
  List<String> keys = universal.typesOfCounters.keys.toList();

  @override
  Widget build(BuildContext context) {
    if (widget.isChangingCounter == false) return SizedBox();

    return Container(
        decoration: lifepadBoxDecoration(widget.lifepadModel.color),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (rowIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rowIndex != 1 ? 2 : 3, (itemIndex) {
                int iconIndex = itemIndex + rowIndex * 2;
                if (rowIndex == 1 && itemIndex == 2) iconIndex--;
                String currentCounter = keys[iconIndex];

                if (rowIndex == 1 && itemIndex == 1) {
                  return Container(
                      constraints: BoxConstraints.tightFor(
                          width: widget.constraints.maxHeight * 0.25, height: widget.constraints.maxHeight * 0.25));
                }

                return Stack(
                  children: [
                    Positioned(
                      bottom: 1,
                      left: 0,
                      right: 0,
                      child: Icon(Icons.more_horiz_rounded,
                          size: widget.constraints.maxHeight * .066,
                          color: Colors.white
                              .withOpacity(widget.lifepadModel.currentTypeOfCounter == currentCounter ? 1 : 0.0)),
                    ),
                    LifepadIconButton(
                      constraints: widget.constraints,
                      iconData: universal.typesOfCounters[currentCounter],
                      iconColor: Colors.white
                          .withOpacity(widget.lifepadModel.currentTypeOfCounter == currentCounter ? 1 : 0.50),
                      onPressed: () => widget.onChangingCounter(currentCounter),
                      iconSizeMultiplier: 0.2,
                    ),
                  ],
                );
              }),
            );
          }),
        ));
  }
}
