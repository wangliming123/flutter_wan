
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