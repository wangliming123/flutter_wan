
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/util/DialogUtils.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 668)
    );
    return getLayout();
  }

  void initData();

  Widget getLayout();

  void finish() {
    Navigator.of(context).pop();
  }


  Future<void> showCoverLoading() {
    return DialogUtils.showCustomDialog(context, clickOutsideClose: false, barrierDismissible: false,
    child: Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: Colors.black54
      ),
      padding: EdgeInsets.all(10.w),
      child: Image(
        image: AssetImage("images/loading_icon.gif"),
      ),
    ));
  }
}
