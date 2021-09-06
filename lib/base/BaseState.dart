import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/util/DialogUtils.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getLayout();
  }

  void initData();

  Widget getLayout();

  void finish() {
    Navigator.of(context).pop();
  }

  var _isLoadingShowing = false;

  showCoverLoading() {
    if (_isLoadingShowing) {
      return;
    }
    _isLoadingShowing = true;
    return DialogUtils.showCustomDialog(
      context,
      clickOutsideClose: false,
      barrierDismissible: false,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: Colors.black54,
        ),
        padding: EdgeInsets.all(10.w),
        child: Image(
          image: AssetImage("images/loading_icon.gif"),
        ),
      ),
    );
  }

  ///不可单独调用，必须先调用[showCoverLoading]
  void hideCoverLoading() {
    if (!_isLoadingShowing) {
      return;
    }
    _isLoadingShowing = false;
    Navigator.of(context).pop();
  }

  void invalidate() {
    setState(() {});
  }
}
