import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class ItemArticle extends StatelessWidget {
  dynamic article;

  ItemArticle(this.article);

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
                ).padding(top: 5.w, bottom: 5.w, right: 20.w)
              ],
            )
          ],
        ).padding(
          left: 10.w,
        ),
      ),
    );
  }
}
