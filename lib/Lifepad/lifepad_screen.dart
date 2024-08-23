import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/components/button_column.dart';
import 'package:lifekeeper/Lifepad/components/life_text.dart';
import 'package:lifekeeper/Lifepad/components/lifepad_icon_button.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';
import 'package:lifekeeper/Lifepad/screens/lifepad_death_screen.dart';
import 'package:lifekeeper/Lifepad/style/lifepad_screen_decoration.dart';
import 'package:lifekeeper/Lifepad/screens/changing_counters.dart';
import 'package:lifekeeper/universal.dart' as universal;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LifepadScreen extends StatefulWidget {
  const LifepadScreen({super.key, required this.index});
  final int index;
  @override
  State<LifepadScreen> createState() => _LifepadScreenState();
}

class _LifepadScreenState extends State<LifepadScreen> {
  late LifepadModel lifepadModel;
  late String currentCounter;
  bool isAttacking = false;
  bool isChangingCounter = false;

  setDead() {
    setState(() {
      lifepadModel.isDead = !lifepadModel.isDead;
    });
  }

  setChangingCounter() {
    setState(() {
      isChangingCounter = !isChangingCounter;
    });
  }

  setupLifepad() => setState(() {
        lifepadModel = universal.lifepadModels[widget.index];
        currentCounter = lifepadModel.currentTypeOfCounter;
        lifepadModel.counters[currentCounter] = lifepadModel.life;
      });

  setCounterIcon(String counter) {
    setState(() {
      isChangingCounter = !isChangingCounter;
      lifepadModel.currentTypeOfCounter = counter;
      currentCounter = lifepadModel.currentTypeOfCounter;
    });
  }

  void modifyValue(int index) {
    setState(() {
      lifepadModel.counters[currentCounter] = lifepadModel.counters[currentCounter]! + (index == 0 ? 1 : -1);
      if (lifepadModel.counters[currentCounter]! < 0) {
        lifepadModel.counters[currentCounter] = 0;
      }
      if (lifepadModel.counters["Infect"]! > 10) {
        lifepadModel.counters["Infect"] = 10;
      }
      if ((lifepadModel.counters["Life"]! <= 0 || lifepadModel.counters["Infect"]! >= 10) && !lifepadModel.isDead) {
        if (lifepadModel.counters["Infect"]! > 10) lifepadModel.counters["Infect"]! + -1;
        if (lifepadModel.counters["Life"]! <= 0) lifepadModel.counters["Life"]! + 1;
        lifepadModel.isDead = true;
      }
    });
  }

  @override
  void initState() {
    setupLifepad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
          quarterTurns: (widget.index < universal.maxNumberOfPlayers / 2) ? 1 : 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedContainer(
                  padding: EdgeInsets.zero,
                  duration: Duration(milliseconds: 100),
                  decoration: lifepadScreenDecoration(lifepadModel),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LifeText(lifepadModel: lifepadModel),
                      Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 9,
                        child: Text(lifepadModel.currentTypeOfCounter,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      ButtonColumn(onPressed: modifyValue),
                      LifepadIconButton(
                        constraints: constraints,
                        alignment: Alignment.topLeft,
                        iconData: Icons.color_lens_outlined,
                      ),
                      LifepadIconButton(
                        constraints: constraints,
                        alignment: Alignment.bottomLeft,
                        iconData: MdiIcons.swordCross,
                      ),
                      LifepadIconButton(
                        constraints: constraints,
                        alignment: Alignment(0, 0.75),
                        iconData: universal.typesOfCounters[currentCounter],
                        onPressed: setChangingCounter
                      ),

                      
                      ChaningCounterScreen(
                        constraints: constraints,
                        lifepadModel: lifepadModel,
                        isChangingCounter: isChangingCounter,
                        onChangingCounter: setCounterIcon,
                      ),
                      LifepadDeathScreen(
                        lifepadModel: lifepadModel,
                        constraints: constraints,
                        onPressed: setDead,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
