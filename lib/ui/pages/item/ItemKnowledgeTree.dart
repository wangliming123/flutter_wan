import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ItemKnowledgeTree extends StatelessWidget {
  final dynamic knowledge;

  ItemKnowledgeTree(this.knowledge);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.w),
      elevation: 3.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiUtils.text(
            knowledge["name"],
            16.sp,
            ColorRes.textColorPrimary,
            maxLines: 1,
          ),
          UiUtils.text(
            (knowledge["children"] as List<dynamic>)
                .map((e) => e["name"])
                .join("    "),
            15.sp,
            ColorRes.textColorSecondary,
            fontHeight: 1.5,
          ).padding(top: 5.w),
        ],
      ).paddingAll(8.w),
    ).onTap(() => _goKnowledgeInfo(context));
  }

  void _goKnowledgeInfo(BuildContext context) {
    Navigator.pushNamed(context, RouteConst.knowledgeInfo, arguments: knowledge);
  }
}
