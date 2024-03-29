import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/util/Extension.dart';

class UiUtils {
  static Widget buildImagePure(
    String? path, {
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
    String? placeHolder,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path == null) {
      return Container();
    }
    var lowercase = path.toLowerCase();
    if (lowercase.isEmpty ||
        lowercase.startsWith("http://") ||
        lowercase.startsWith("https://")) {
      placeHolder = placeHolder ?? "images/default_pic.png";
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => Image(
          image: AssetImage(placeHolder!),
          fit: fit,
          width: width,
          height: height,
        ),
        errorWidget: (context, url, error) => Image(
          image: AssetImage(path),
          fit: fit,
          width: width,
          height: height,
        ),
      );
    } else if (lowercase.startsWith("images/")) {
      return Image(
        image: AssetImage(path),
        fit: fit,
        width: width,
        height: height,
      );
    } else {
      return Image(
        image: FileImage(File(path)),
        fit: fit,
        width: width,
        height: height,
      );
    }
  }

  static Widget text(
    String text,
    double size,
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
    double fontHeight = 1,
    TextAlign? textAlign = TextAlign.start,
    int? maxLines = 100,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: fontWeight,
        fontFamily: "Arial",
        height: fontHeight,
      ),
    );
  }

  static Widget htmlText(
    String data,
    double size,
    Color color, {
    int? maxLines = 100,
  }) {
    return Html(
      data: data,
      style: {
        "*": Style(
          fontSize: FontSize(size),
          color: color,
        ),
        "a": Style(
          textDecoration: TextDecoration.none,
          color: Colors.blue,
        )
      },
    );
  }

  static TextField buildTextField({
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    Color? textColor,
    Color? hintColor,
    String text = "",
    String? hintText,
    double? fontSize,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    double contentPadding = 0,
    bool isCollapsed = false,
    FocusNode? focusNode,
    Function? onText,
    bool obscureText = false,
    bool enable = true,
  }) {
    return TextField(
      enabled: enable,
      obscureText: obscureText,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      maxLength: maxLength,
      textAlign: textAlign,
      style: TextStyle(color: textColor, fontSize: fontSize),
      cursorColor: textColor,
      cursorWidth: 1.w,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, height: 1.1.w),
        border: InputBorder.none,
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            horizontal: contentPadding, vertical: contentPadding),
        isCollapsed: isCollapsed,
      ),
      onChanged: (value) {
        onText?.call(value);
      },
      maxLines: maxLines,
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: text,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: text.length,
            ),
          ),
        ),
      ),
    );
  }

  static Widget textFieldNew({
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxlength,
    Color? textColor,
    Color? hintColor,
    String text = "",
    String? hintText,
    double? fontSize,
    TextAlign txtAlign = TextAlign.start,
    int maxLines = 1,
    double contentPadding = 0,
    TextEditingController? controller,
    Function? onText,
  }) {
    //逐步去除onText回调，这玩意儿不如controller好用
    TextField field = TextField(
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      maxLength: maxlength,
      textAlign: txtAlign,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
      cursorColor: textColor,
      cursorWidth: 1.w,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        border: InputBorder.none,
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            horizontal: contentPadding, vertical: contentPadding),
        isCollapsed: true,
      ),
      onChanged: (value) {
        onText?.call(value);
      },
      maxLines: maxLines,
      controller: controller,
    );
    return field;
  }

  static Widget lineTabButton(
    String text,
    double textSize, {
    double? width,
    double? height,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
    TextAlign textAlign = TextAlign.left,
    Widget? leftIcon,
    Widget? rightIcon,
    Function? onTap,
  }) {
    List<Widget> widgets = [];
    if (leftIcon != null) {
      widgets.add(leftIcon.padding(left: 10.w));
    }
    var textWidget = UiUtils.text(text, textSize, textColor,
            textAlign: textAlign, maxLines: 1)
        .padding(left: 10.w)
        .expanded();
    widgets.add(textWidget);
    if (rightIcon != null) {
      widgets.add(rightIcon.padding(right: 10.w));
    }
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: Row(
        children: widgets,
      ),
    ).onTap(() {
      if (onTap == null) {
        "暂未开放".toast();
      } else {
        onTap.call();
      }
    });
  }
}
