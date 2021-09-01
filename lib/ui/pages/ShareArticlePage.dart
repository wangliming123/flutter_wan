import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/Buttons.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ShareArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShareArticleState();
  }
}

class ShareArticleState extends BaseState<ShareArticlePage> {
  String _title = "";
  String _link = "";
  String _tipText = "";
  bool _tipVisible = false;

  void _saveTitle(String value) {
    _title = value;
  }

  void _saveLink(String value) {
    _link = value;
  }

  void _shareArticle() async {
    if (!checkValid()) {
      return;
    }
    try {
      var body = {"title": _title, "link": _link};
      await ApiService.ins().postHttpAsync("lg/user_article/add/json", querys: body);
      Navigator.pop(context);
    } on ApiException catch(e) {
      e.msg?.toast();
    }
  }

  bool checkValid() {
    if (_title.isEmpty) {
      setState(() {
        _tipVisible = true;
        _tipText = "文章标题不能为空";
      });
      return false;
    }
    if (_link.isEmpty) {
      setState(() {
        _tipVisible = true;
        _tipText = "文章链接不能为空";
      });
      return false;
    }
    if (!_link.startsWith("http://") && !_link.startsWith("https://")) {
      setState(() {
        _tipVisible = true;
        _tipText = "文章链接必须以http://或https://开头";
      });
      return false;
    }
    _tipVisible = false;
    return true;
  }

  @override
  Widget getLayout() {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              height: 45.w,
              child: UiUtils.buildTextField(
                textAlign: TextAlign.start,
                text: _title,
                textColor: "#333333".color,
                hintColor: "#8d8d8d".color,
                hintText: "文章标题（100字以内）",
                fontSize: 18.sp,
                onText: _saveTitle,
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
              margin: EdgeInsets.only(left: 20.w, top: 30.w, right: 20.w),
              height: 45.w,
              child: UiUtils.buildTextField(
                textAlign: TextAlign.start,
                inputType: TextInputType.url,
                text: _link,
                textColor: "#333333".color,
                hintColor: "#8d8d8d".color,
                hintText: "文章链接",
                fontSize: 18.sp,
                onText: _saveLink,
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
              margin: EdgeInsets.only(left: 20.w, top: 8.w),
              height: 20.w,
              child: Text(
                _tipText,
                style: TextStyle(fontSize: 12.sp, color: Colors.red),
              ).visible(_tipVisible),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 30.w, right: 10),
                  child: CommonButton(
                    enabled: true,
                    text: "分享",
                    height: 45.w,
                    radius: 50.w,
                    textSize: 18.sp,
                    onTap: () => _shareArticle(),
                  ),
                ).expanded(),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 30.w, right: 20.w),
                  child: CommonButton(
                    enabled: true,
                    text: "取消",
                    height: 45.w,
                    radius: 50.w,
                    textSize: 18.sp,
                    enableColor: Colors.grey,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initData() {
    // TODO: implement initData
  }
}
