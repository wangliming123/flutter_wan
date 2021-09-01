import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/ui/pages/item/ItemKnowledgeView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class KnowledgeInfoPage extends StatefulWidget {
  final dynamic knowledge;

  KnowledgeInfoPage(this.knowledge);

  @override
  State<StatefulWidget> createState() {
    print(knowledge);
    return KnowledgeInfoState();
  }
}

class KnowledgeInfoState extends BaseState<KnowledgeInfoPage>
    with TickerProviderStateMixin {
  List<dynamic> children = [];
  TabController? _tabController;
  List<Widget> _widget = [];

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
  void initData() {
    if (widget.knowledge == null) {
      Navigator.pop(context);
      return;
    }

    print('===initData===');
    children = widget.knowledge["children"] ?? [];
    print(children.length);

    _tabController = new TabController(length: children.length, vsync: this);
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
