import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/ui/widget/CommonButton.dart';
import 'package:flutter_wan/util/TextUtils.dart';
import 'package:flutter_wan/util/exUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState<LoginPage> extends BaseState {
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  String _username = "";
  String _password = "";

  GlobalKey<CommonButtonState> btnKey = GlobalKey();

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
                    child: Container(
                      child: TextUtils.buildTextField(
                        focusNode: _usernameFocus,
                        textAlign: TextAlign.start,
                        text: _username,
                        textColor: "#333333".color,
                        hintColor: "#8d8d8d".color,
                        hintText: "请输入用户名",
                        fontSize: 18.sp,
                        onText: (value) {
                          saveUserName(value);
                        },
                      ),
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
                    child: Container(
                      child: TextUtils.buildTextField(
                        focusNode: _usernameFocus,
                        textAlign: TextAlign.start,
                        inputType: TextInputType.visiblePassword,
                        text: _username,
                        textColor: "#333333".color,
                        hintColor: "#8d8d8d".color,
                        hintText: "请输入密码",
                        fontSize: 18.sp,
                        onText: (value) {
                          savePassword(value);
                        },
                      ),
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
                    child: Text(
                      "用户名或密码错误",
                      style: TextStyle(fontSize: 12.sp, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.w, top: 30.w, right: 30.w),
                    child: CommonButton(
                      key: btnKey,
                      text: "登录",
                      textSize: 18,
                      isEnable: true,
                      onClick: () {
                        login();
                      },
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

  void login() {

  }

}
