import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/ui/widget/ImageView.dart';
import 'package:flutter_wan/util/styleUtils.dart';

class CommonButton extends StatefulWidget {
  String text;
  double textSize;
  double height;
  String? icon;
  BoxDecoration? buttonBg;

  bool isEnable = false;

  GestureTapCallback onClick;
  CommonButton({
    Key? key,
    this.text = "",
    this.textSize = 16,
    this.height = 50,
    this.isEnable = true,
    this.icon,
    this.buttonBg,
    required this.onClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CommonButtonState(
      text: text,
      textSize: textSize,
      height: height,
      isEnable: isEnable,
      icon: icon,
      normal: buttonBg,
      onClick: onClick,
    );
  }
}

class CommonButtonState<CommonButton> extends BaseState {
  String text;
  double textSize;
  double height;
  String? icon;
  bool isEnable = false;
  Function onClick;

  CommonButtonState({
    required this.text,
    required this.textSize,
    required this.height,
    required this.isEnable,
    this.icon,
    BoxDecoration? normal,
    BoxDecoration? pressed,
    required this.onClick,
  }) {
    _normal = normal ?? _normal;
    _pressed = pressed ?? _pressed;
  }

  BoxDecoration _normal = BoxDecoration(
      borderRadius: BorderRadius.circular(50.w), color: Colors.blue);
  BoxDecoration _pressed = BoxDecoration(
    borderRadius: BorderRadius.circular(50.w),
    color: Color(0xFFe2e2e2),
  );

  bool isPressed = false;
  BoxDecoration? btnBg;

  void setEnable(bool isEnable) {
    setState(() {
      this.isEnable = isEnable;
    });
  }

  void setText(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget getLayout() {
    if (isEnable) {
      if (isPressed) {
        btnBg = _pressed;
      } else {
        btnBg = _normal;
      }
    } else {
      btnBg = _pressed;
    }
    return Listener(
      onPointerDown: (event) {
        if (isEnable) {
          setState(() {
            isPressed = true;
          });
        }
      },
      onPointerUp: (event) {
        if (isEnable) {
          if (isPressed) {
            onClick();
          }
          setState(() {
            isPressed = false;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: height.w,
        decoration: btnBg,
        child: Row(
          children: [
            Visibility(
              child: imageView.buildImage(icon ?? "", width: 22, height: 22),
              visible: icon != null,
            ),
            Text(
              text,
              style: SimpleTextStyle(fontSize: textSize, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initData() {}
}
