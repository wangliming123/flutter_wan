import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/EventBus.dart';
import 'package:flutter_wan/util/DialogUtils.dart';
import 'package:flutter_wan/util/Extension.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getLayout();
  }

  void initData();

  Widget getLayout();

  void finish() {
    Navigator.of(context).pop();
  }

  var _isLoadingShowing = false;

  OverlayEntry? overlayEntry;
  showCoverLoading() {
    if (overlayEntry != null) {
      return;
    }
    overlayEntry = new OverlayEntry(builder: (content) {
      return LoadingWidget();
    });
    Overlay.of(context)?.insert(overlayEntry!);
  }

  ///不可单独调用，必须先调用[showCoverLoading]
  void hideCoverLoading() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  bool hasDisposed = false;
  void invalidate() {
    if (hasDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    hasDisposed = true;
    //页面退栈时，移除全部事件监听
    _removeEvent();
    super.dispose();
  }

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _eventList = new Map<String, List<EventCallback>>();
  addEvent(String eventName, EventCallback callback) {
    _eventList[eventName] ??= [];
    _eventList[eventName]!.add(callback);
    bus.on(eventName, callback);
  }

  //移除所有监听
  void _removeEvent() {
    _eventList.forEach((key, value) {
      for (EventCallback f in value) {
        bus.off(key, f);
      }
    });
  }
}


class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            color: Colors.black54,
          ),
          padding: EdgeInsets.all(10.w),
          child: Image(
            image: AssetImage("images/loading_icon.gif"),
          ),
        ),
      ),
    ).onTap(() {});
  }
}
