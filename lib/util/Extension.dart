import 'package:flutter/material.dart';

extension ColorEx on String {
  Color get color {
    if (this.startsWith("#") && (this.length == 7 || this.length == 9)) {
      String res;
      if (this.length == 7) {
        res = this.replaceAll("#", "0xFF");
      } else {
        res = this.replaceAll("#", "0x");
      }
      return Color(int.parse(res));
    } else {
      return Colors.white;
    }
  }
}

extension WidgetEx on Widget {
  Widget visible(visible) {
    return Visibility(
      child: this,
      visible: visible,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      child: this,
      flex: flex,
    );
  }

  Widget onTap(Function() onTap, {Function()? onLongPress}) {
    return GestureDetector(
      child: this,
      onTap: onTap,
      onLongPress: () => {onLongPress?.call()},
    );
  }

  Widget onPress(Function(PointerDownEvent) onPress,
      {Function(PointerUpEvent)? onPressUp}) {
    return Listener(
      child: this,
      onPointerDown: onPress,
      onPointerUp: (event) => {onPressUp?.call(event)},
    );
  }

  Widget padding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: this,
    );
  }
}
