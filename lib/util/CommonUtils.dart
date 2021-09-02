import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmartRefreshBuilder {
  static InheritedWidget buildApp({required Widget child}) {
    return RefreshConfiguration(
        // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
        headerBuilder: () => ClassicHeader(
              idleText: "下拉刷新",
              releaseText: "松开立即刷新",
              refreshingText: "正在刷新...",
              completeText: "刷新成功",
              failedText: "刷新失败",
              textStyle: SimpleTextStyle(fontSize: 12.sp),
            ),
        // 配置默认底部指示器
        footerBuilder: () => ClassicFooter(
              idleText: "加载更多",
              failedText: "加载失败",
              loadingText: "加载中...",
              noDataText: "没有更多了",
              textStyle: SimpleTextStyle(fontSize: 12),
              loadStyle: LoadStyle.ShowWhenLoading,
            ),
        // 头部触发刷新的越界距离
        headerTriggerDistance: 80.0,
        // 自定义回弹动画
        springDescription:
            SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxOverScrollExtent: 100,
        // 底部最大可以拖动的范围
        maxUnderScrollExtent: 100,
        //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableScrollWhenRefreshCompleted: true,
        //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        enableLoadingWhenFailed: false,
        // Viewport不满一屏时,禁用上拉加载更多功能
        hideFooterWhenNotFull: true,
        // 可以通过惯性滑动触发加载更多
        enableBallisticLoad: true,
        child: child);
  }
}
