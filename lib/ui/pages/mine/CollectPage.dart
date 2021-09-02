import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../item/ItemArticle.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectState();
  }
}

class _CollectState extends BaseState<CollectPage> {
  int _state = PageStateView.showLoading;
  int _page = 0;
  int _pageCount = -1;
  int _pageSize = 10;
  List<dynamic> mList = [];

  RefreshController _refreshController = RefreshController();

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
            UiUtils.text("我的收藏", 18.sp, ColorRes.textColorPrimary, maxLines: 1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: ColorRes.defaultBg,
        child: PageStateView(
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
                return Container(
                  child: ItemArticle(
                    mList[index],
                    invalidate,
                    idName: "originId",
                    onUnCollect: () => _removeArticle(index),
                  ),
                );
              },
            ),
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
      var data =
          await ApiService.ins().getHttpAsync("lg/collect/list/$_page/json");
      _pageCount = data["pageCount"] ?? -1;
      _page++;
      _pageSize = data["size"] ?? 10;
      if (data["datas"] is List) {
        data["datas"].forEach((element) {
          element["collect"] = true;
        });
      }
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
      var data = await ApiService.ins().getHttpAsync("lg/collect/list/0/json");
      if (data["datas"] is List) {
        data["datas"].forEach((element) {
          element["collect"] = true;
        });
      }
      _page = 1;
      _pageCount = data["pageCount"] ?? -1;
      _pageSize = data["size"] ?? 10;
      mList.clear();
      mList.addAll(data["datas"] ?? []);
      _state =
          mList.isEmpty ? PageStateView.showEmpty : PageStateView.showContent;
    } on ApiException catch (e) {
      e.msg?.toast();
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
          await ApiService.ins().getHttpAsync("lg/collect/list/$_page/json");
      if (data["datas"] is List) {
        data["datas"].forEach((element) {
          element["collect"] = true;
        });
      }
      _pageSize = data["size"] ?? 10;
      _pageCount = data["pageCount"] ?? -1;
      _page++;
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

  void _removeArticle(int index) {
    mList.removeAt(index);
    invalidate();
    if (mList.length < _pageSize) {
      _onRefresh();
    }
  }
}
