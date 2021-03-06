
import 'package:dio/dio.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/util/SpUtils.dart';

class AppInterceptor extends Interceptor {

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? cookies = await SpUtils.getInstance().getString(SpConst.cookie);

    if (cookies != null) {
      options.headers.addAll({"Cookie": cookies});
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    var cookies = response.headers.map["Set-Cookie"];
    if (cookies != null && cookies.isNotEmpty) {
      var sb = StringBuffer();
      sb.writeAll(cookies, ",");
      await SpUtils.getInstance().putString(SpConst.cookie, sb.toString());
    }
    super.onResponse(response, handler);
  }
}