
import 'package:dio/dio.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/util/SpUtils.dart';

class AppInterceptor extends Interceptor {

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? cookies = SpUtils.getInstance().getString(SpConst.cookie);
    if (cookies != null) {
      cookies.split(",").forEach((element) {
        options.headers.addAll({"Cookie": element});
      });
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    var cookies = response.headers.map["Set-Cookie"];
    if (cookies != null && cookies.isNotEmpty) {
      var sb = StringBuffer();
      cookies.forEach((element) {
        sb.write("$element,");
      });
      await SpUtils.getInstance().putString(SpConst.cookie, sb.toString());
    }
    super.onResponse(response, handler);
  }
}