
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'item/ItemArticle.dart';

class SquarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SquareState();
  }
}

class SquareState<SquarePage> extends BaseState {
  int _state = PageStateView.showLoading;
  int _page = 0;
  int _pageCount = -1;
  List<dynamic> mList = [];

  RefreshController _refreshController = RefreshController();

  @override
  Widget getLayout() {
    return Scaffold(
      body: Container(
        color: ColorRes.defaultBg,
        child: Column(
          children: [
            Container(height: ScreenUtil().statusBarHeight, color: Colors.white,),
            PageStateView(
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
                    return ItemArticle(mList[index]);
                  },
                ),
              ),
            ).expanded(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, RouteConst.shareArticle);
      }),
    );
  }

  @override
  void initData() async {
    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
      var data =
          await ApiService.ins().getHttpAsync("user_article/list/$_page/json");
      _pageCount = data["pageCount"] ?? -1;
      _page++;
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
      var data =
          await ApiService.ins().getHttpAsync("user_article/list/$_page/json");
      mList.clear();
      _pageCount = data["pageCount"] ?? -1;
      _page++;
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
          await ApiService.ins().getHttpAsync("user_article/list/$_page/json");
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
}
