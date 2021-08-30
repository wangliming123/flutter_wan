
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return WebViewState();
  }
}

class WebViewState<WebViewPage> extends BaseState {
  @override
  Widget getLayout() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().statusBarHeight,),
            getWebView().expanded(),
          ],
        ),
      ),
    );
  }

  @override
  void initData() {

  }

  Widget getWebView() {
    return WebView();
  }
}