import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/GlobalValues.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/Buttons.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/SpUtils.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends BaseState<LoginPage> {
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  String _username = "";
  String _password = "";

  bool _loginFailed = false;

  GlobalKey<CommonButtonState> btnKey = GlobalKey();
  GlobalKey<CommonButtonState> btnKey2 = GlobalKey();

  @override
  Widget getLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: clickBlack,
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      top: 24.w + ScreenUtil().statusBarHeight,
                    ),
                    child: Text(
                      "注册/登录",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w, top: 40.w, right: 30.w),
                    height: 45.w,
                    child: UiUtils.buildTextField(
                      focusNode: _usernameFocus,
                      textAlign: TextAlign.start,
                      text: _username,
                      textColor: "#333333".color,
                      hintColor: "#8d8d8d".color,
                      hintText: "请输入用户名",
                      fontSize: 18.sp,
                      onText: saveUserName,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                    ),
                    height: 1.w,
                    color: "#E2E2E2".color,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w, top: 40.w, right: 30.w),
                    height: 45.w,
                    child: UiUtils.buildTextField(
                      obscureText: true,
                      focusNode: _passwordFocus,
                      textAlign: TextAlign.start,
                      inputType: TextInputType.visiblePassword,
                      text: _password,
                      textColor: "#333333".color,
                      hintColor: "#8d8d8d".color,
                      hintText: "请输入密码",
                      fontSize: 18.sp,
                      onText: savePassword,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                    ),
                    height: 1.w,
                    color: "#E2E2E2".color,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30.w, top: 8.w),
                    height: 20.w,
                    child: Text(
                      "用户名或密码错误",
                      style: TextStyle(fontSize: 12.sp, color: Colors.red),
                    ).visible(_loginFailed),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.w, top: 30.w, right: 30.w),
                    child: CommonButton(
                      enabled: true,
                      text: "登录",
                      height: 50.w,
                      radius: 50.w,
                      textSize: 18.sp,
                      onTap: login,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.w, top: 30.w, right: 30.w),
                    child: CommonButton(
                      text: "注册",
                      height: 50.w,
                      radius: 50.w,
                      textSize: 18,
                      enabled: true,
                      onTap: register,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initData() {}

  void clickBlack() {
    _usernameFocus.unfocus();
    _passwordFocus.unfocus();
  }

  void saveUserName(String value) {
    _username = value;
  }

  void savePassword(String value) {
    _password = value;
  }

  login() async {
    showCoverLoading();
    try {
      var res = await ApiService.ins().postHttpAsync(context, "user/login",
          querys: {"username": _username, "password": _password});
      hideCoverLoading();
      SpUtils.getInstance().putBool(SpConst.isLogin, true);
      SpUtils.getInstance().putString(SpConst.username, _username);
      SpUtils.getInstance().putString(SpConst.password, _password);
      SpUtils.getInstance().putInt(SpConst.userId, res["id"]);
      GlobalValues.userId = res["id"];
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConst.mainPage, (route) => false);
    } on ApiException catch(e) {
      e.toString().toast();
      hideCoverLoading();
    }
    print('login');
  }

  void register() async {
    try {
      var res = await ApiService.ins().postHttpAsync(context, "user/register", querys: {
        "username": _username,
        "password": _password,
        "repassword": _password
      });
      hideCoverLoading();
      SpUtils.getInstance().putBool(SpConst.isLogin, true);
      SpUtils.getInstance().putString(SpConst.username, _username);
      SpUtils.getInstance().putString(SpConst.password, _password);
      SpUtils.getInstance().putInt(SpConst.userId, res["id"]);
      GlobalValues.userId = res["id"];
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConst.mainPage, (route) => false);
    } on ApiException catch(e) {
      e.toString().toast();
      hideCoverLoading();
    }
    print('register');
  }
}
