import 'package:flutter/material.dart';

class DialogUtils {
  static Future<T?> showCustomDialog<T>(BuildContext context, {
    Widget? child,
    Color barrierColor = Colors.transparent,
    Alignment alignment = Alignment.center,
    bool clickOutsideClose = true, //点击空白返回
    bool barrierDismissible = true, //是否允许返回键
  }) async {
    return showDialog<T>(
        context: context,
        barrierColor: barrierColor,
        builder: (context) {
          return WillPopScope(child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              child: Container(
                alignment: alignment,
                child: GestureDetector(
                  child: child,
                  onTap: () {}, //默认内容区域不透传事件
                ),
              ),
              onTap: () {
                if (clickOutsideClose) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ), onWillPop: () async => barrierDismissible,);
        });
  }
}