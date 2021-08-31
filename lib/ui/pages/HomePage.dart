import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'WebViewPage.dart';
import 'item/ItemArticle.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState<HomePage> extends BaseState {
  int _state = PageStateView.showLoading;
  int _page = 0;
  int _pageCount = -1;

  List<dynamic> mList = [];
  List<dynamic> bannerList = [];

  RefreshController _refreshController = RefreshController();

  @override
  Widget getLayout() {
    return PageStateView(
      state: _state,
      onEmptyClick: initData,
      onErrorClick: initData,
      contentView: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _loadMore,
        child: ListView.builder(
          itemCount: mList.length,
          itemBuilder: (BuildContext context, int index) {
            if (mList[index]["isBanner"] == true)
              return getBannerView();
            else
              return ItemArticle(mList[index]);
          },
        ),
      ),
    );
  }

  _goBannerInfo(int index) {
    dynamic bannerData = bannerList[index];
    Navigator.pushNamed(context, RouteConst.webView,
        arguments: WebUrl(bannerData["url"], bannerData["title"]));
  }

  @override
  void initData() async {
    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
      var banners = await ApiService.ins().getHttpAsync("banner/json");
      bannerList.addAll(banners ?? []);
      var top = await ApiService.ins().getHttpAsync("article/top/json");
      if (top is List) {
        top.forEach((element) {
          element["isTop"] = true;
        });
      }
      var data =
          await ApiService.ins().getHttpAsync("article/list/$_page/json");
      _pageCount = data["pageCount"] ?? -1;
      _page++;
      if (bannerList.isNotEmpty) {
        dynamic banner = {"isBanner": true};
        mList.add(banner);
      }
      mList.addAll(top ?? []);
      mList.addAll(data["datas"] ?? []);
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

  void _onRefresh() async {
    try {
      var banners = await ApiService.ins().getHttpAsync("banner/json");
      bannerList.clear();
      bannerList.addAll(banners ?? []);
      var top = await ApiService.ins().getHttpAsync("article/top/json");
      if (top is List) {
        top.forEach((element) {
          element["isTop"] = true;
        });
      }
      var data =
          await ApiService.ins().getHttpAsync("article/list/$_page/json");
      _pageCount = data["pageCount"] ?? -1;
      _page = 1;
      mList.clear();
      if (bannerList.isNotEmpty) {
        dynamic banner = {"isBanner": true};
        mList.add(banner);
      }
      mList.addAll(top ?? []);
      mList.addAll(data["datas"] ?? []);
      _state =
          mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
    } on ApiException catch (e) {
      e.msg?.toast();
      _state = PageStateView.showError;
    } finally {
      _refreshController.refreshCompleted();
      if (mounted) {
        invalidate();
      }
    }
  }

  void _loadMore() async {
    try {
      if (_page >= _pageCount) {
        StringRes.noMoreData.toast();
        return;
      }
      var data =
          await ApiService.ins().getHttpAsync("article/list/$_page/json");
      mList.addAll(data["datas"] ?? []);
      _state =
          mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
    } on ApiException catch (e) {
      e.msg?.toast();
    } finally {
      _refreshController.loadComplete();
      if (mounted) {
        invalidate();
      }
    }
  }

  Widget getBannerView() {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      height: 220.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            var bannerData = bannerList[index];
            return UiUtils.buildImagePure(
              bannerData["imagePath"],
              fit: BoxFit.fill,
            );
          },
          itemCount: bannerList.length,
          scrollDirection: Axis.horizontal,
          loop: true,
          autoplay: true,
          autoplayDelay: 5000,
          onTap: _goBannerInfo,
        ),
      ),
    );
  }
}
