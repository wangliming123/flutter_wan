import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/ui/pages/mine/ItemTodoListPage.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends BaseState<TodoListPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  List<ItemTodoListPage> _widgets = [ItemTodoListPage(true), ItemTodoListPage(false)];
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
        toolbarHeight: 90.w,
        title:
            UiUtils.text("待办清单", 18.sp, ColorRes.textColorPrimary, maxLines: 1),
        backgroundColor: Colors.white,
        bottom: TabBar(
          tabs: [
            Tab(text: "待办"),
            Tab(text: "已完成"),
          ],
          controller: _tabController,
          isScrollable: true,
          indicatorColor: ColorRes.colorPrimary,
          labelColor: ColorRes.colorPrimary,
          unselectedLabelColor: ColorRes.textColorSecondary,
          labelStyle: TextStyle(height: 2.w),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            TabBarView(
              controller: _tabController,
              children: _widgets,
            ).expanded(),
          ],
        ),
      ),
    );
  }

  @override
  void initData() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController!.addListener(() {
      if (_tabController!.index.toDouble() == _tabController!.animation?.value) {
        _widgets[_tabController!.index].state.onRefresh();
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
