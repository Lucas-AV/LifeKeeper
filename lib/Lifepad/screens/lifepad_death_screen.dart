import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';
import 'package:lifekeeper/Old/style.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LifepadDeathScreen extends StatelessWidget {
  const LifepadDeathScreen({super.key, required this.lifepadModel, required this.constraints, this.onPressed});
  final LifepadModel lifepadModel;
  final BoxConstraints constraints;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    if(!lifepadModel.isDead) return SizedBox();
    
    return RawMaterialButton(
      onPressed: onPressed,
      child: Container(
        decoration: lifepadBoxDecoration(lifepadModel.color),
        alignment: Alignment.center,
        child: Icon(lifepadModel.counters["Infect"] == 10 ? MdiIcons.biohazard : MdiIcons.skullOutline,
            size: constraints.maxHeight * .75, color: lifepadModel.fontColor.withOpacity(0.66)),
      ),
    );
  }
}
