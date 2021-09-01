import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class CommonButton extends StatelessWidget {
//可点击时背景色
  Color _enableColor = Colors.blue;

  //不可点击时背景色
  Color _disableColor = ColorRes.e2e2e2;

  //文本颜色
  Color _textColor = Colors.white;

  //文本字体大小
  double _textSize = 18.sp;

  //上边距
  double _topMargin = 0;

  //下边距
  double _botMargin = 0;

  //点击回调
  Function? _onTap;

  //------------必须参数-----------
  //是否可点击
  bool _enabled = false;

  //按钮宽度
  double? _width = 100;

  //按钮高度
  double? _height = 30;
  double _radius = 50;

  //文本内容
  String _text = "";

  CommonButton(
      {required String text,
      bool enabled = true,
      double? width,
      double? height,
      double radius = 50,
      Color? enableColor,
      Color? disableColor,
      Color? textColor,
      double? textSize,
      double? topMargin,
      double? botMargin,
      Function? onTap}) {
    _enabled = enabled;
    _text = text;
    _width = width;
    _height = height;
    _radius = radius;

    _enableColor = enableColor ?? _enableColor;
    _disableColor = disableColor ?? _disableColor;
    _textColor = textColor ?? _textColor;
    _textSize = textSize ?? _textSize;
    _topMargin = topMargin ?? _topMargin;
    _botMargin = botMargin ?? _botMargin;
    _onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: _topMargin,
        bottom: _botMargin,
      ),
      decoration: BoxDecoration(
        color: _enabled ? _enableColor : _disableColor,
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
      ),
      child: UiUtils.text(
        _text,
        _textSize,
        _textColor,
      ),
    ).onTap(() {
      if (_enabled) {
        _onTap?.call();
      }
    });
  }
}

class CommonButton2 extends StatefulWidget {
  final String text;
  final double textSize;
  final double height;
  final String? icon;
  final BoxDecoration? buttonBg;

  bool isEnable = false;

  final GestureTapCallback onClick;

  CommonButton2({
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

class CommonButtonState extends BaseState<CommonButton2> {
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
              child:
                  UiUtils.buildImagePure(icon ?? "", width: 22.w, height: 22.w),
              visible: icon != null,
            ),
            UiUtils.text(
              text,
              textSize,
              Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initData() {}
}
