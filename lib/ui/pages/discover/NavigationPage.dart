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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  final ItemScrollController _itemsScrollController = ItemScrollController();
  final ItemScrollController _navScrollController = ItemScrollController();
  ItemPositionsListener _navListener = ItemPositionsListener.create();
  ItemPositionsListener _itemsListener = ItemPositionsListener.create();

  int _lastFirstIndex = 0;
  bool moveByTap = false;

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
        contentView: Row(
          children: [
            ScrollablePositionedList.builder(
              addAutomaticKeepAlives: true,
              minCacheExtent: 600.w,
              itemCount: mList.length,
              itemBuilder: (context, index) {
                return _getNav(index);
              },
              itemScrollController: _navScrollController,
              itemPositionsListener: _navListener,
            ).expanded(flex: 2),
            Container(
              width: 1.w,
              color: ColorRes.e2e2e2,
            ).paddingAll(5.w),
            ScrollablePositionedList.builder(
              addAutomaticKeepAlives: true,
              minCacheExtent: 600.w,
              itemCount: mList.length,
              itemBuilder: (context, index) {
                return _getItems(context, index);
              },
              itemScrollController: _itemsScrollController,
              itemPositionsListener: _itemsListener,
            ).expanded(flex: 5),
          ],
        ),
        // ListView.builder(
        //   itemCount: mList.length,
        //   itemBuilder: (context, index) {
        //     return _getNavArticleItem(context, index);
        //   },
        // ).paddingAll(10.w),
      ),
    );
  }

  void Function()? moveListener;

  @override
  void initData() async {
    moveListener = () {
      var positions = _itemsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        int firstIndex = positions
            .where((element) => element.itemTrailingEdge > 0)
            .reduce((min, position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;
        print('firstIndex= $firstIndex');
        if (_lastFirstIndex != firstIndex && mounted) {
          _lastFirstIndex = firstIndex;
          invalidate();

          _navScrollController.scrollTo(
              index: firstIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear);
        }
      }
    };
    _itemsListener.itemPositions.addListener(moveListener!);

    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
      var data = await ApiService.ins().getHttpAsync(context, "navi/json");
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

  Widget _getNav(int index) {
    return Container(
      alignment: Alignment.center,
      height: 50.w,
      child: UiUtils.text(
        mList[index]["name"],
        16.sp,
        _lastFirstIndex == index
            ? ColorRes.colorPrimary
            : ColorRes.textColorSecondary,
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(color: ColorRes.defaultBg),
    ).onTap(() {
      int dif = (_lastFirstIndex - index).abs();
      int duration = 0;
      if (dif < 1) {
        return;
      } else if (dif <= 2) {
        duration = 500;
      } else if (dif <= 5) {
        duration = 1000;
      } else if (dif <= 10) {
        duration = 2000;
      } else {
        duration = 4000;
      }
      _lastFirstIndex = index;
      invalidate();
      _itemsListener.itemPositions.removeListener(moveListener!);
      _itemsScrollController
          .scrollTo(
              index: index,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear)
          .then((value) {
        Future.delayed(Duration(milliseconds: duration), () {
          _itemsScrollController.isAttached;
          _itemsListener.itemPositions.addListener(moveListener!);
        });
      });
    });
  }

  Widget _getItems(BuildContext context, int index) {
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
