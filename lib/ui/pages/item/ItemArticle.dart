import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/pages/WebViewPage.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/SpUtils.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ItemArticle extends StatelessWidget {
  final dynamic article;
  final void Function() onRefresh;
  final void Function()? onUnCollect;
  final void Function()? onDeleteShare;
  final bool showDelete;
  final String idName;

  ItemArticle(
    this.article,
    this.onRefresh, {
    this.onUnCollect,
    this.onDeleteShare,
    this.showDelete = false,
    this.idName = "id",
  });

  @override
  Widget build(BuildContext context) {
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
    if (article["author"] != null && article["author"].toString().isNotEmpty) {
      author = article["author"];
    } else if (article["shareUser"] != null &&
        article["shareUser"].toString().isNotEmpty) {
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
            Container(
              height: 50.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UiUtils.text(chapter, 12.sp, ColorRes.colorPrimary)
                      .padding(left: 5.w, top: 10.w, bottom: 10.w, right: 5.w)
                      .onTap(() => _goChapterShare(context)),
                  Spacer(),
                  Icon(
                    const IconData(58959,
                        fontFamily: "iconfont1"),
                    color: Colors.red,
                  ).paddingAll(8.w).onTap(() => _collectArticle(context)).visible(article["collect"] == true),
                  Icon(
                    const IconData(58960,
                        fontFamily: "iconfont1"),
                    color: Colors.red,
                  ).paddingAll(8.w).onTap(() => _collectArticle(context)).visible(article["collect"] != true),
                  Icon(
                    const IconData(58914, fontFamily: "iconfont1"),
                    color: Colors.grey,
                  )
                      .onTap(() => _confirmDeleteShare(context))
                      .padding(left: 20.w)
                      .visible(showDelete),
                ],
              ),
            ),
          ],
        ).padding(
          left: 10.w,
        ),
      ),
    ).onTap(() => _goArticleInfo(context));
  }

  _collectArticle(BuildContext context) async {
    bool isLogin =
        await SpUtils.getInstance().getBool(SpConst.isLogin) ?? false;
    if (!isLogin) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConst.loginPage, (route) => false);
      return;
    }
    try {
      if (article["collect"] == true) {
        article["collect"] = false;
        onRefresh();
        await ApiService.ins()
            .postHttpAsync(context, "lg/uncollect_originId/${article[idName]}/json");
        onUnCollect?.call();
      } else {
        article["collect"] = true;
        onRefresh();
        await ApiService.ins()
            .postHttpAsync(context, "lg/collect/${article[idName]}/json");
      }
    } on ApiException catch (e) {
      e.msg?.toast();
      article["collect"] = !article["collect"];
      onRefresh();
    }
  }

  _goArticleInfo(BuildContext context) {
    Navigator.pushNamed(context, RouteConst.webView,
        arguments: WebUrl(article["link"], article["title"]));
  }

  void _confirmDeleteShare(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: UiUtils.text("确认删除分享？", 16.sp, ColorRes.textColorPrimary),
          actions: [
            TextButton(
              child: UiUtils.text("取消", 14.sp, ColorRes.colorPrimary),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: UiUtils.text("确定", 14.sp, ColorRes.colorPrimary),
              onPressed: () {
                Navigator.pop(context);
                _deleteShare(context);
              },
            ),
          ],
        );
      },
    );
  }

  _deleteShare(BuildContext context) async {
    try {
      await ApiService.ins()
          .postHttpAsync(context, "lg/user_article/delete/${article["id"]}/json");
      onDeleteShare?.call();
    } on ApiException catch (e) {
      e.msg?.toast();
    }
  }

  void _goChapterShare(BuildContext context) async {
    int superId = article["realSuperChapterId"];
    int id = article["chapterId"];
    var knowledge;
    try {
      var data = await ApiService.ins().getHttpAsync(context, "tree/json");
      if (data is List) {
        for (var element in data) {
          if (element["id"] == superId) {
            knowledge = element;
            break;
          }
        }
      }
    } on ApiException catch(e) {
      e.msg?.toast();
      return;
    }
    Navigator.pushNamed(context, RouteConst.knowledgeInfo, arguments: {
      "knowledge": knowledge,
      "id": id,
    });
  }
}
