import 'package:flutter/material.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ItemArticle.dart';

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

  RefreshController _refreshController = RefreshController();

  @override
  Widget getLayout() {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _loadMore,
        child: PageStateView(
          state: _state,
          onEmptyClick: initData,
          onErrorClick: initData,
          contentView: ListView.builder(
            itemCount: mList.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemArticle(mList[index]);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initData() async {
    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
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
      mList.addAll(top ?? []);
      mList.addAll(data["datas"] ?? []);
      setState(() {
        _state =
            mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
      });
    } on ApiException catch (e) {
      e.msg?.toast();
      setState(() {
        _state = PageStateView.showError;
      });
    }
  }

  void _onRefresh() async {
    try {
      var top = await ApiService.ins().getHttpAsync("article/top/json");
      if (top is List) {
        top.forEach((element) {
          element["isTop"] = true;
        });
      }
      _page = 0;
      var data =
          await ApiService.ins().getHttpAsync("article/list/$_page/json");
      _pageCount = data["pageCount"] ?? -1;
      _page++;
      mList.clear();
      mList.addAll(top ?? []);
      mList.addAll(data["datas"] ?? []);
      setState(() {
        _state =
            mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
      });
    } on ApiException catch (e) {
      e.msg?.toast();
      setState(() {
        _state = PageStateView.showError;
      });
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  void _loadMore() async {
    try {
      if (_page >= _pageCount) {
        StringRes.noMoreData.toast();
        return;
      }
      var data = await ApiService.ins().getHttpAsync(
          "article/list/$_page/json");
      mList.addAll(data["datas"] ?? []);
      setState(() {
        _state =
        mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
      });
    } on ApiException catch (e) {
      e.msg?.toast();
    } finally {
      _refreshController.loadComplete();
    }
  }
}
