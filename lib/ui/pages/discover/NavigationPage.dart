import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

import '../WebViewPage.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends BaseState<NavigationPage> {
  int _state = PageStateView.showLoading;

  List<dynamic> mList = [];

  @override
  Widget getLayout() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorRes.textColorPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50.w,
        title:
            UiUtils.text("导航", 18.sp, ColorRes.textColorPrimary, maxLines: 1),
        backgroundColor: Colors.white,
      ),
      body: PageStateView(
        state: _state,
        onEmptyClick: initData,
        onErrorClick: initData,
        contentView: ListView.builder(
          itemCount: mList.length,
          itemBuilder: (context, index) {
            return _getNavArticleItem(context, index);
          },
        ).paddingAll(10.w),
      ),
    );
  }

  @override
  void initData() async {
    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
      var data = await ApiService.ins().getHttpAsync("navi/json");
      mList.addAll(data ?? []);
      _state =
          mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
    } on ApiException catch (e) {
      e.msg?.toast();
      _state = PageStateView.showError;
    } finally {
      if (mounted) {
        invalidate();
      }
    }
  }

  Widget _getNavItem(int index) {
    return Container(
      alignment: Alignment.center,
      height: 50.w,
      child: UiUtils.text(
        mList[index]["name"],
        16.sp,
        ColorRes.textColorSecondary,
      ),
    );
  }

  Widget _getNavArticleItem(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiUtils.text(mList[index]["name"], 18.sp, ColorRes.textColorPrimary)
            .paddingAll(10.w),
        Wrap(
          spacing: 5.w,
          runSpacing: 5.w,
          children: _getArticleItem(context, index),
        ),
      ],
    );
  }

  List<Widget> _getArticleItem(BuildContext context, int index) {
    List<dynamic> articles = mList[index]["articles"];
    return articles.map((article) {
      return Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: ColorRes.colorPrimary,
            borderRadius: BorderRadius.all(Radius.circular(10.w))),
        child: UiUtils.text(article["title"], 14.sp, Colors.white),
      ).onTap(() {
        _goArticleInfo(context, article);
      });
    }).toList();
  }

  _goArticleInfo(BuildContext context, dynamic article) {
    print('${article["link"]},  ${article["title"]}');
    Navigator.pushNamed(context, RouteConst.webView,
        arguments: WebUrl(article["link"], article["title"]));
  }
}

class CustomScrollDelegate extends SliverChildBuilderDelegate {
  final Function(int firstIndex, int lastIndex, double leadingScrollOffset,
      double trailingScrollOffset)? scrollCallback;

  CustomScrollDelegate(
      {required NullableIndexedWidgetBuilder builder,
      int? childCount,
      this.scrollCallback})
      : super(builder, childCount: childCount);

  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    print(
        'firstIndex= $firstIndex,  lastIndex= $lastIndex},  leadingScrollOffset= $leadingScrollOffset},  trailingScrollOffset= $trailingScrollOffset}');
    scrollCallback?.call(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}