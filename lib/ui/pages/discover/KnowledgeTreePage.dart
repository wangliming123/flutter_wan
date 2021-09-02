import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/pages/item/ItemKnowledgeTree.dart';
import 'package:flutter_wan/ui/widget/PageStateView.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class KnowledgeTreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KnowledgeTreeState();
  }
}

class KnowledgeTreeState extends BaseState<KnowledgeTreePage> {
  int _state = PageStateView.showLoading;
  List<dynamic> mList = [];

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
      backgroundColor: Colors.white,
      body: PageStateView(
        state: _state,
        onEmptyClick: initData,
        onErrorClick: initData,
        contentView: ListView.builder(
          itemCount: mList.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemKnowledgeTree(mList[index]);
          },
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
      var data = await ApiService.ins().getHttpAsync("tree/json");
      mList.addAll(data ?? []);
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

}
