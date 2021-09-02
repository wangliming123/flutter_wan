import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      child: this,
      flex: flex,
    );
  }

  Widget onTap(void Function() onTap, {void Function()? onLongPress}) {
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

  Widget paddingAll(double all) {
    return Padding(
      padding: EdgeInsets.all(all),
      child: this,
    );
  }

  Widget position({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      child: this,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
    );
  }
}

extension StringEx on String {
  void toast() {
    Fluttertoast.showToast(
      msg: this,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }
}
