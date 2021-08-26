import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/ui/pages/HomePage.dart';
import 'package:flutter_wan/ui/pages/MinePage.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState<MainPage> extends BaseState {
  var _index = 0;
  List<Widget> _widgets = [HomePage(), MinePage()];

  @override
  Widget getLayout() {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: _index,
            children: _widgets,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage("images/ic_home.png"),
              fit: BoxFit.cover,
              width: 20.w,
              height: 20.w,
            ),
            activeIcon: Image(
              image: AssetImage("images/ic_home_selected.png"),
              fit: BoxFit.cover,
              width: 20.w,
              height: 20.w,
            ),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage("images/ic_mine.png"),
              fit: BoxFit.cover,
              width: 20.w,
              height: 20.w,
            ),
            activeIcon: Image(
              image: AssetImage("images/ic_mine_selected.png"),
              fit: BoxFit.cover,
              width: 20.w,
              height: 20.w,
            ),
            label: "我的",
          ),
        ],
        onTap: _selectPage,
        currentIndex: _index,
      ),
    );
  }

  @override
  void initData() {}

  void _selectPage(int index) {
    setState(() {
      _index = index;
    });
  }
}
