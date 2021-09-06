import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/GlobalValues.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/util/SpUtils.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      bool isLogin = await SpUtils.getInstance().getBool(SpConst.isLogin) ?? false;
      print('isLogon $isLogin');
      if (isLogin) {
        String username = await SpUtils.getInstance().getString(SpConst.username);
        String password = await SpUtils.getInstance().getString(SpConst.password);
        GlobalValues.userId = await SpUtils.getInstance().getInt(SpConst.userId);
        ApiService.ins().postHttpAsync(context, "user/login",
            querys: {"username": username, "password": password});
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConst.mainPage, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConst.loginPage, (route) => false);
      }
    });
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "splash",
        style: TextStyle(color: Colors.blue, fontSize: 24.sp),
      ),
    );
  }
}
