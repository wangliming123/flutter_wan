import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/GlobalValues.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/EventBus.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/SpUtils.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class MinePage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends BaseState<MinePage> {
  bool isLogin = false;
  @override
  Widget getLayout() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiUtils.lineTabButton(
              "浏览历史",
              16.sp,
              textColor: ColorRes.textColorPrimary,
              height: 50.w,
              leftIcon:
              Icon(const IconData(58881, fontFamily: "iconfont1"), size: 25.w),
              rightIcon: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pushNamed(context, RouteConst.history);
              }
          ).padding(top: 5.w, bottom: 5.w),
          UiUtils.lineTabButton(
            "我的收藏",
            16.sp,
            textColor: ColorRes.textColorPrimary,
            height: 50.w,
            leftIcon:
            Icon(const IconData(58882, fontFamily: "iconfont1"), size: 25.w),
            rightIcon: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pushNamed(context, RouteConst.collect);
            },
          ).padding(top: 5.w, bottom: 5.w).visible(isLogin),
          UiUtils.lineTabButton(
            "我的分享",
            16.sp,
            textColor: ColorRes.textColorPrimary,
            height: 50.w,
            leftIcon:
            Icon(const IconData(59089, fontFamily: "iconfont1"), size: 25.w),
            rightIcon: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pushNamed(context, RouteConst.userShare);
            },
          ).padding(top: 5.w, bottom: 5.w).visible(isLogin),
          UiUtils.lineTabButton(
            "待办清单",
            16.sp,
            textColor: ColorRes.textColorPrimary,
            height: 50.w,
            leftIcon:
            Icon(const IconData(59117, fontFamily: "iconfont1"), size: 25.w),
            rightIcon: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.pushNamed(context, RouteConst.todoList);
            },
          ).padding(top: 5.w, bottom: 5.w).visible(isLogin),
          UiUtils.lineTabButton(
            "关于",
            16.sp,
            textColor: ColorRes.textColorPrimary,
            height: 50.w,
            leftIcon:
            Icon(const IconData(58984, fontFamily: "iconfont1"), size: 25.w),
            rightIcon: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showAbout(context);
            },
          ).padding(top: 5.w, bottom: 5.w),
          UiUtils.lineTabButton(
            isLogin ? "退出登录" : "登录",
            16.sp,
            textColor: ColorRes.textColorPrimary,
            height: 50.w,
            leftIcon:
            Icon(const IconData(59166, fontFamily: "iconfont1"), size: 25.w),
            rightIcon: Icon(Icons.keyboard_arrow_right),
            onTap: () => {
              if (isLogin) {
                logout(context)
              } else {
                Navigator.pushNamed(context, RouteConst.loginPage)
              }
            },
          ).padding(top: 5.w, bottom: 5.w),
        ],
      ),
    );
  }

  @override
  void initData() {
    isLogin = SpUtils.getInstance().getBoolAlways(SpConst.isLogin) ?? false;
    addEvent(LOGIN_SUCCESS, (arg) {
      refreshLoginState();
    });
  }
  void refreshLoginState() {
    isLogin = SpUtils.getInstance().getBoolAlways(SpConst.isLogin) ?? false;
    print("refreshLoginState");
    print(isLogin);
    invalidate();
  }

  void logout(BuildContext context) async {
    await SpUtils.getInstance().removeData(SpConst.username);
    await SpUtils.getInstance().removeData(SpConst.userId);
    await SpUtils.getInstance().removeData(SpConst.password);
    await SpUtils.getInstance().removeData(SpConst.cookie);
    await SpUtils.getInstance().removeData(SpConst.isLogin);
    GlobalValues.userId = null;
    refreshLoginState();
    bus.emit(LOGOUT_EVENT);
    Navigator.pushNamed(context, RouteConst.loginPage);
  }

  void showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: UiUtils.text("玩安卓", 20.sp, ColorRes.textColorPrimary),
          content: UiUtils.text(
            "源码地址：https://github.com/wangliming123/flutter_wan",
            16.sp,
            ColorRes.textColorSecondary,
          ),
          actions: [
            TextButton(
              child: UiUtils.text("复制", 14.sp, ColorRes.colorPrimary),
              onPressed: () {
                Navigator.pop(
                    context, "https://github.com/wangliming123/flutter_wan");
              },
            ),
            TextButton(
              child: UiUtils.text("确定", 14.sp, ColorRes.colorPrimary),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        Clipboard.setData(ClipboardData(text: value));
        "已复制到剪切板".toast();
      }
    });
  }
}
