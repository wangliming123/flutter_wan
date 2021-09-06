import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ItemTodo extends StatelessWidget {
  static const int TODO_STATUS_TODO = 0; //未完成
  static const int TODO_STATUS_FINISHED = 1; //已完成

  final dynamic todo;

  final void Function() onRefresh;

  ItemTodo(this.todo, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    String dateTxt = todo["status"] == TODO_STATUS_FINISHED
        ? "完成：${todo["completeDateStr"]}"
        : "预完成：${todo["dateStr"]}";

    return Card(
      margin: EdgeInsets.all(5.w),
      elevation: 3.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiUtils.text(todo["title"], 16.sp, ColorRes.textColorPrimary),
              UiUtils.text(
                  todo["content"], 14.sp, ColorRes.textColorSecondary).padding(top: 8.w),
              UiUtils.text(dateTxt, 14.sp, ColorRes.textColorSecondary).padding(top: 8.w, bottom: 8.w),
            ],
          ).padding(left: 10.w, top: 8.w, bottom: 8.w).expanded(),
          Spacer(),
          Icon(
            const IconData(58925, fontFamily: "iconfont1"),
            color: Colors.grey,
          ).paddingAll(8.w).onTap(() => _handleTodo(context)).visible(todo["status"] == TODO_STATUS_FINISHED),
          Icon(
            const IconData(58964, fontFamily: "iconfont1"),
            color: Colors.grey,
          ).paddingAll(8.w).onTap(() => _handleTodo(context)).visible(todo["status"] != TODO_STATUS_FINISHED),
          Icon(
            const IconData(58914, fontFamily: "iconfont1"),
            color: Colors.grey,
          ).paddingAll(8.w).onTap(() => _deleteTodo(context)),
        ],
      ),
    );
  }

  _handleTodo(BuildContext context) async {
    int newStatus = todo["status"] == TODO_STATUS_FINISHED ? 0 : 1;
    try {
      await ApiService.ins().postHttpAsync(context, "lg/todo/done/${todo["id"]}/json", querys: {"status" : newStatus});
      onRefresh.call();
    } on ApiException catch (e) {
      e.msg?.toast();
    }
  }

  _deleteTodo(BuildContext context) async {
    try {
      await ApiService.ins().postHttpAsync(context, "lg/todo/delete/${todo["id"]}/json");
      onRefresh.call();
    } on ApiException catch (e) {
      e.msg?.toast();
    }
  }
}
