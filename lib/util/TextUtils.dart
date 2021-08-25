import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextUtils {
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
    FocusNode? focusNode,
    Function? onText,
  }) {
    return TextField(
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      maxLength: maxLength,
      textAlign: textAlign,
      style: TextStyle(color: textColor, fontSize: fontSize, height: 1.1.w),
      cursorColor: textColor,
      cursorWidth: 1.w,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, height: 1.1.w),
          border: InputBorder.none,
          counterText: ""),
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
}
