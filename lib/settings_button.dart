import 'package:flutter/material.dart';


class SettingsButton extends StatefulWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black54,
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                blurRadius: 1
            )
          ]
      ),
      height: 60,
      width: 60,
      child: RawMaterialButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        shape: CircleBorder(),
        onPressed: (){},
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
                "assets/d20_outlined.png",
                color: Colors.white
            )
        ),
      ),
    );
  }
}
