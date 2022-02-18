import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/database/DatabaseEntity.dart';
import 'package:flutter_wan/database/DatabaseService.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/ui/pages/item/ItemArticle.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/UiUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_wan/util/Extension.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryState();
  }
}

class _HistoryState extends BaseState<HistoryPage> {
  int _state = PageStateView.showLoading;
  int _pageCount = -1;
  int _offset = 0;
  int _limit = 10;
  List<History> mList = [];

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
            UiUtils.text("浏览历史", 18.sp, ColorRes.textColorPrimary, maxLines: 1),
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
                    json.decode(mList[index].articleInfo),
                    invalidate,
                    idName: mList[index].idName,
                    createTime: formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            mList[index].createTime),
                        [yyyy, "-", mm, "-", dd, " ", HH, ":", nn, ":", ss]),
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

      var database = await DatabaseService.ins().getDatabase();
      var data = await database.historyDao.queryHistoryByPage(_offset, _limit);
      // var data = await database.historyDao.queryHistory();

      _pageCount = data.length;
      _offset += _limit;
      mList.addAll(data);
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
      _offset = 0;

      var database = await DatabaseService.ins().getDatabase();
      var data = await database.historyDao.queryHistoryByPage(_offset, _limit);
      _pageCount = data.length;
      _offset += _limit;
      mList.addAll(data);
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
      if (_pageCount < _limit) {
        StringRes.noMoreData.toast();
        return;
      }

      var database = await DatabaseService.ins().getDatabase();
      var data = await database.historyDao.queryHistoryByPage(_offset, _limit);
      _pageCount = data.length;
      _offset += _limit;

      mList.addAll(data);
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
