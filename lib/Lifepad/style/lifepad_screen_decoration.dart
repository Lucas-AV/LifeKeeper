import 'package:flutter/material.dart';
import 'package:lifekeeper/Lifepad/lifepad_model.dart';

BoxDecoration lifepadScreenDecoration(LifepadModel lifepadModel) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: lifepadModel.color.withOpacity(0.8),
    boxShadow: [
      BoxShadow(
        color: lifepadModel.color.withOpacity(0.5),
        blurRadius: 1
      ),
    ],
  );
}