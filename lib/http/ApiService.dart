import 'package:dio/dio.dart';
import 'package:flutter_wan/common/BuildConfig.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/AppInterceptor.dart';

class ApiService {
  static final baseUrl = "https://www.wanandroid.com/";

  ApiService._internal();

  static ApiService _instance = ApiService._internal();

  factory ApiService.ins() => _instance;

  late Dio dio;

  init() {
    dio = Dio(BaseOptions(
        baseUrl: baseUrl, connectTimeout: 30000, receiveTimeout: 30000));
    dio.interceptors.add(AppInterceptor());
    if (BuildConfig.getCompileMode() == "debug") {
      dio.interceptors.add(LogInterceptor(requestBody: true));
    }
  }

  getHttpAsync(String action, {Map<String, dynamic>? querys}) async {
    var response = await dio.get(action, queryParameters: querys);
    resolveResponse(response);
  }

  dynamic resolveResponse(Response response) {
    if (response.statusCode == 200) {
      var res = response.data;
      var code = res["errorCode"];
      var msg = res["errorMsg"];
      var data = res["data"];
      if (code != -1) return data;
      else throw ApiException(code, msg);
    } else {
      throw ApiException(-1, "网络异常");
    }
  }
}
