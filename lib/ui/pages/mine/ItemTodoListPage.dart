import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/pages/item/ItemTodo.dart';
import 'package:flutter_wan/ui/widget/Buttons.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ItemTodoListPage extends StatefulWidget {
  final bool showAdd;

  ItemTodoListPage(this.showAdd);

  late _ItemTodoListState state;

  @override
  State<StatefulWidget> createState() {
    state = _ItemTodoListState();
    return state;
  }
}

class _ItemTodoListState extends BaseState<ItemTodoListPage>
    with AutomaticKeepAliveClientMixin {
  int _state = PageStateView.showLoading;
  int _page = 1;
  int _pageCount = -1;

  List<dynamic> mList = [];
  List<dynamic> bannerList = [];

  RefreshController _refreshController = RefreshController();

  bool showAddTab = false;

  DateTime _dateTime = DateTime.now();

  String _title = "";
  String _content = "";
  String _dateStr = "";
  String _tipText = "";
  bool _tipVisible = false;

  void _saveTitle(String value) {
    _title = value;
  }

  void _saveContent(String value) {
    _content = value;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getLayout();
  }

  @override
  Widget getLayout() {
    return Stack(
      children: [
        PageStateView(
          state: _state,
          onEmptyClick: initData,
          onErrorClick: initData,
          contentView: SmartRefresher(
            controller: _refreshController,
            enablePullUp: true,
            onRefresh: onRefresh,
            onLoading: _loadMore,
            child: ListView.builder(
              itemCount: mList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemTodo(mList[index], () {
                  onRefresh();
                });
              },
            ),
          ),
        ).visible(!showAddTab),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              height: 45.w,
              child: UiUtils.buildTextField(
                textAlign: TextAlign.start,
                text: _title,
                textColor: "#333333".color,
                hintColor: "#8d8d8d".color,
                hintText: "标题",
                fontSize: 18.sp,
                onText: _saveTitle,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorRes.e2e2e2, width: 1.w))),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.w, top: 20.w, right: 20.w),
              height: 45.w,
              child: UiUtils.buildTextField(
                textAlign: TextAlign.start,
                inputType: TextInputType.text,
                text: _content,
                textColor: "#333333".color,
                hintColor: "#8d8d8d".color,
                hintText: "详情",
                fontSize: 18.sp,
                onText: _saveContent,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorRes.e2e2e2, width: 1.w))),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.w, top: 20.w, right: 20.w),
              height: 45.w,
              child: UiUtils.buildTextField(
                enable: false,
                textAlign: TextAlign.start,
                inputType: TextInputType.datetime,
                text: _dateStr,
                textColor: "#333333".color,
                hintColor: "#8d8d8d".color,
                hintText: "请选择预定完成时间",
                fontSize: 18.sp,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorRes.e2e2e2, width: 1.w))),
            ).onTap(() {
              _showDatePicker();
            }),
            Container(
              margin: EdgeInsets.only(left: 20.w, top: 8.w),
              height: 20.w,
              child: Text(
                _tipText,
                style: TextStyle(fontSize: 12.sp, color: Colors.red),
              ).visible(_tipVisible),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 30.w, right: 10),
                  child: CommonButton(
                    enabled: true,
                    text: "保存",
                    height: 45.w,
                    radius: 50.w,
                    textSize: 18.sp,
                    onTap: () => _saveTodo(),
                  ),
                ).expanded(),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 30.w, right: 20.w),
                  child: CommonButton(
                    enabled: true,
                    text: "取消",
                    height: 45.w,
                    radius: 50.w,
                    textSize: 18.sp,
                    enableColor: Colors.grey,
                    onTap: () {
                      setState(() {
                        showAddTab = false;
                      });
                    },
                  ),
                ).expanded(),
              ],
            ),
          ],
        ).visible(showAddTab),
        FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 32.w,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              showAddTab = true;
            });
          },
        )
            .position(right: 30, bottom: 30.w)
            .visible(widget.showAdd && !showAddTab),
      ],
    );
  }

  @override
  void initData() async {
    _dateStr = formatDate(_dateTime, ["yyyy", '-', "mm", '-', 'dd']);
    try {
      setState(() {
        _state = PageStateView.showLoading;
      });
      var data = await ApiService.ins().getHttpAsync(
          context, "lg/todo/v2/list/$_page/json",
          querys: {"status": widget.showAdd ? 0 : 1});
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

  void onRefresh() async {
    try {
      var data = await ApiService.ins().getHttpAsync(
          context, "lg/todo/v2/list/1/json",
          querys: {"status": widget.showAdd ? 0 : 1});
      _page = 2;
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
      var data = await ApiService.ins().getHttpAsync(
          context, "lg/todo/v2/list/$_page/json",
          querys: {"status": showAddTab ? 0 : 1});
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

  _saveTodo() async {
    if (!checkValid()) {
      return;
    }
    try {
      var body = {"title": _title, "content": _content, "date": _dateStr};
      await ApiService.ins()
          .postHttpAsync(context, "lg/todo/add/json", querys: body);
      setState(() {
        showAddTab = false;
      });
      onRefresh();
    } on ApiException catch (e) {
      e.msg?.toast();
    }
  }

  bool checkValid() {
    if (_title.isEmpty) {
      setState(() {
        _tipVisible = true;
        _tipText = "标题不能为空";
      });
      return false;
    }
    if (_content.isEmpty) {
      setState(() {
        _tipVisible = true;
        _tipText = "详情不能为空";
      });
      return false;
    }
    if (_dateStr.isEmpty) {
      setState(() {
        _tipVisible = true;
        _tipText = "请选择日期";
      });
      return false;
    }

    _tipVisible = false;
    return true;
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _dateTime,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
            fieldHintText: "如：2000/01/01")
        .then((value) async {
      if (value != null) {
        setState(() {
          _dateTime = value;
          _dateStr = formatDate(value, ["yyyy", '-', "mm", '-', 'dd']);
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
