import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/pages/item/ItemKnowledgeView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class KnowledgeInfoPage extends StatefulWidget {
  final dynamic knowledge;

  final int? id;

  KnowledgeInfoPage({this.knowledge, this.id});

  @override
  State<StatefulWidget> createState() {
    return KnowledgeInfoState();
  }
}

class KnowledgeInfoState extends BaseState<KnowledgeInfoPage>
    with TickerProviderStateMixin {
  List<dynamic> children = [];
  var initIndex = 0;
  TabController? _tabController;
  List<Widget> _widget = [];

  @override
  Widget getLayout() {
    print('===getLayout===');
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
        title: UiUtils.text(
            widget.knowledge["name"], 18.sp, ColorRes.textColorPrimary,
            maxLines: 1),
        backgroundColor: Colors.white,
        bottom: TabBar(
          tabs: children.map((e) => Tab(text: e["name"],)).toList(),
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
              children: _widget,
            ).expanded(),
          ],
        ),
      ),
    );
  }

  @override
  void initData() async {
    if (widget.knowledge == null) {
      Navigator.pop(context);
      return;
    }

    print('===initData===');
    children = widget.knowledge["children"] ?? [];
    if (widget.id != null) {
      for (var i = 0; i < children.length; i++) {
        var c = widget.knowledge["children"];
        if (c is List) {
          for (var i = 0; i < c.length; i++) {
            if (c[i]["id"] == widget.id) {
              initIndex = i;
              break;
            }
          }
        }
      }
    }
    print(children.length);

    _tabController = new TabController(length: children.length, vsync: this, initialIndex: initIndex);
    _widget = getKnowledgeView();
  }

  List<Widget> getKnowledgeView() {
    return children.map((e) => ItemKnowledgeView(e["id"])).toList();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
