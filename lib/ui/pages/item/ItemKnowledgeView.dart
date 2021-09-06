import 'package:flutter/material.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ItemArticle.dart';

class ItemKnowledgeView extends StatefulWidget {
  final int knowledgeId;

  ItemKnowledgeView(this.knowledgeId);

  @override
  State<StatefulWidget> createState() {
    return _ItemKnowledgeState();
  }
}

class _ItemKnowledgeState extends BaseState<ItemKnowledgeView> with AutomaticKeepAliveClientMixin {
  int _state = PageStateView.showLoading;
  int _page = 0;
  int _pageCount = -1;

  List<dynamic> mList = [];

  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getLayout();
  }

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
            return ItemArticle(mList[index], invalidate);
          },
        ),
      ),
    );
  }

  @override
  void initData() async {
    try {
      var data = await ApiService.ins()
          .getHttpAsync(context, "article/list/$_page/json?cid=${widget.knowledgeId}");
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
      var data = await ApiService.ins()
          .getHttpAsync(context, "article/list/0/json?cid=${widget.knowledgeId}");
      _page = 1;
      _pageCount = data["pageCount"] ?? -1;
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
      var data = await ApiService.ins()
          .getHttpAsync(context, "article/list/$_page/json?cid=${widget.knowledgeId}");
      _page++;
      _pageCount = data["pageCount"] ?? -1;
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

  @override
  bool get wantKeepAlive => true;
}
