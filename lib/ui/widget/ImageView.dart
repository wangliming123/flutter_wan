import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class imageView extends Image {
  imageView._ins() : super.asset("images/black_white.png");

  static Widget buildImage(
    String? path, {
    required double width,
    required double height,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
  }) {
    return Container(
      width: width.w,
      height: height.w,
      padding: padding,
      margin: margin,
      child: buildImagePure(path),
    );
  }

  static buildImagePure(String? path, {double width = 0, double height = 0}) {
    if (path == null) {
      return Container();
    }
    var lowercase = path.toLowerCase();
    if (lowercase.isEmpty ||
        lowercase.startsWith("http://") ||
        lowercase.startsWith("https://")) {
      return Image(
        image: NetworkImage(path),
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    } else if (lowercase.startsWith("images/")) {
      return Image(
        image: AssetImage(path),
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    } else {
      return Image(
        image: FileImage(File(path)),
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }
  }
}
