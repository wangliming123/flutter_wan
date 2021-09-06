import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/ui/pages/DiscoverPage.dart';
import 'package:flutter_wan/ui/pages/HomePage.dart';
import 'package:flutter_wan/ui/pages/MinePage.dart';
import 'package:flutter_wan/util/Extension.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends BaseState<MainPage> {
  var _index = 0;
  List<Widget> _widgets = [HomePage(), DiscoverPage(), MinePage()];

  // PageController _pageController = PageController(initialPage: 0, keepPage: true);
  @override
  Widget getLayout() {
    return WillPopScope(child: Scaffold(
      backgroundColor: ColorRes.defaultBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: ScreenUtil().statusBarHeight, color: Colors.white,),
          IndexedStack(
            index: _index,
            children: _widgets,
          ).padding(top: 8.w).expanded(),
          // PageView(
          //   scrollDirection: Axis.horizontal,
          //   physics: ClampingScrollPhysics(),
          //   children: _widgets,
          //   controller: _pageController,
          //   onPageChanged: _selectPage,
          // )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: ColorRes.colorPrimary,
        onTap: (index) {
          // _pageController.jumpToPage(index);
          _selectPage(index);
        },
        currentIndex: _index,
        iconSize: 20.w,
        items: [
          BottomNavigationBarItem(
            icon: Icon(const IconData(58890, fontFamily: "iconfont1"),),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(const IconData(59186, fontFamily: "iconfont1"),),
            label: "发现",
          ),
          BottomNavigationBarItem(
            icon: Icon(const IconData(58896, fontFamily: "iconfont1"),),
            label: "我的",
          ),
        ],
      ),
    ), onWillPop: _onBackPressed);
  }

  @override
  void initData() {}

  void _selectPage(int index) {
    setState(() {
      _index = index;
    });
  }

  var _lastBackTime = 0;
  Future<bool> _onBackPressed() async {
    var backTime = new DateTime.now().millisecondsSinceEpoch;
    if (backTime - _lastBackTime <= 2000) {
      return true;
    } else {
      StringRes.doubleClickExitStr.toast();
    }
    _lastBackTime = backTime;
    return false;
  }
}
