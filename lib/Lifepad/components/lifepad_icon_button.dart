import 'package:flutter/material.dart';

class LifepadIconButton extends StatefulWidget {
  const LifepadIconButton({
    super.key,
    required this.constraints,
    this.alignment,
    this.onPressed,
    this.iconData, this.iconColor, this.iconSizeMultiplier,
  });

  final BoxConstraints constraints;
  final Function? onPressed;
  final IconData? iconData;
  final AlignmentGeometry? alignment;
  final Color? iconColor;
  final double? iconSizeMultiplier;
  @override
  State<LifepadIconButton> createState() => _LifepadIconButtonState();
}

class _LifepadIconButtonState extends State<LifepadIconButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.alignment != null) {
      return Align(
        alignment: widget.alignment!,
        child: RawMaterialButton(
          shape: CircleBorder(),
          constraints: BoxConstraints.tightFor(
              width: widget.constraints.maxHeight * 0.2, height: widget.constraints.maxHeight * 0.2),
          onPressed: () {
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          },
          child: Icon(widget.iconData ?? Icons.arrow_circle_right_outlined,
              color: Colors.white, size: widget.constraints.maxHeight * (widget.iconSizeMultiplier ?? 0.125)),
        ),
      );
    } else {
      return RawMaterialButton(
        shape: CircleBorder(),
        constraints: BoxConstraints.tightFor(
            width: widget.constraints.maxHeight * 0.2, height: widget.constraints.maxHeight * 0.2),
        onPressed: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: Icon(
          widget.iconData ?? Icons.arrow_circle_right_outlined,
          size: widget.constraints.maxHeight * 0.125,
          color: widget.iconColor ?? Colors.white,
        ),
      );
    }
  }
}
