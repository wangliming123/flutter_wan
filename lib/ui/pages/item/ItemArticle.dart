
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/pages/WebViewPage.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/SpUtils.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ItemArticle extends StatefulWidget {
  final dynamic article;

  ItemArticle(this.article);

  @override
  State<StatefulWidget> createState() {
    return ItemArticleState(article);
  }
}

class ItemArticleState<ItemArticle> extends BaseState {
  dynamic article;

  ItemArticleState(this.article);

  @override
  void initData() {}
  
  @override
  Widget getLayout() {
    var chapter = "";
    if (article["superChapterName"] != null &&
        article["superChapterName"].toString().isNotEmpty) {
      chapter = chapter + article["superChapterName"];
    }
    if (article["chapterName"] != null &&
        article["chapterName"].toString().isNotEmpty) {
      if (chapter.isNotEmpty) {
        chapter = chapter + "/";
      }
      chapter = chapter + article["chapterName"];
    }

    var author = "";
    if (article["author"] != null) {
      author = article["author"];
    } else if (article["shareUser"] != null) {
      author = article["shareUser"];
    }
    return Card(
      margin: EdgeInsets.all(5.w),
      elevation: 3.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
      child: Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                UiUtils.text(author, 12.sp, ColorRes.textColorPrimary)
                    .paddingAll(3.w),
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  padding: EdgeInsets.all(2.w),
                  child: UiUtils.text("置顶", 10.sp, Colors.red),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1.w)),
                ).visible(article["isTop"] ?? false),
                Spacer(),
                UiUtils.text(
                        article["niceDate"], 12.sp, ColorRes.textColorSecondary)
                    .paddingAll(3.w),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UiUtils.buildImagePure(article["envelopePic"], width: 100.w)
                    .visible(article["envelopePic"] != null &&
                        article["envelopePic"].toString().isNotEmpty),
                Column(
                  children: [
                    UiUtils.htmlText(
                        article["title"], 16.sp, ColorRes.textColorPrimary),
                    Container(
                      alignment: Alignment.topLeft,
                      child: UiUtils.htmlText(
                          article["desc"], 14.sp, ColorRes.textColorSecondary),
                    ).visible(article["desc"] != null &&
                        article["desc"].toString().isNotEmpty),
                  ],
                ).expanded()
              ],
            ).padding(top: 5.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UiUtils.text(chapter, 12.sp, ColorRes.colorPrimary),
                Spacer(),
                Icon(
                  IconData(article["collect"] ? 58959 : 58960,
                      fontFamily: "iconfont1"),
                  color: Colors.red,
                )
                    .padding(top: 5.w, bottom: 5.w, right: 20.w)
                    .onTap(() => _collectArticle())
              ],
            )
          ],
        ).padding(
          left: 10.w,
        ),
      ),
    ).onTap(() => _goArticleInfo());
  }

  _collectArticle() async {
    bool isLogin =
        await SpUtils.getInstance().getBool(SpConst.isLogin) ?? false;
    if (!isLogin) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConst.loginPage, (route) => false);
      return;
    }
    try {
      if (article["collect"]) {
        await ApiService.ins()
            .postHttpAsync("lg/uncollect_originId/${article["id"]}/json");
        article["collect"] = false;
      } else {
        await ApiService.ins()
            .postHttpAsync("lg/collect/${article["id"]}/json");
        article["collect"] = true;
      }
    } on ApiException catch (e) {
      e.msg?.toast();
    } finally {
      invalidate();
    }
  }


  _goArticleInfo() {
    Navigator.pushNamed(context, RouteConst.webView, arguments: WebUrl(article["link"], article["title"]));
  }
}
