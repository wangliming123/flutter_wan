
//订阅者回调签名
typedef void EventCallback(Map<String, dynamic>? arg);

class EventBus {
  EventBus._internal();
  static EventBus _instance = EventBus._internal();
  factory EventBus.ins() => _instance;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _eMap = new Map<Object, List<EventCallback>?>();

  void on(String eventName, EventCallback callback) {
    if(eventName.isEmpty) return;
    _eMap[eventName] ??= [];
    _eMap[eventName]!.add(callback);
  }

  //移除订阅者
  void off(String eventName, [EventCallback? f]) {
    var list = _eMap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }


  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(String eventName, [Map<String, dynamic>? arg]) {
    var list = _eMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }

}

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var bus = new EventBus.ins();

const String LOGIN_SUCCESS = "LOGIN_SUCCESS";
const String LOGOUT_EVENT = "LOGOUT_EVENT";