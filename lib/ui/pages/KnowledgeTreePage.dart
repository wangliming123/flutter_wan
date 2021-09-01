import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class KnowledgeTreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KnowledgeTreeState();
  }
}

class KnowledgeTreeState<KnowledgeTreePage> extends BaseState {
  List<Widget> _tabs = [];

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
            UiUtils.text("知识体系", 18.sp, ColorRes.textColorPrimary, maxLines: 1),
        backgroundColor: Colors.white,
      ),
      body: Container(),
    );
  }

  @override
  void initData() {}
}
