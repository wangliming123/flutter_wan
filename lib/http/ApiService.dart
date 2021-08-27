import 'package:dio/dio.dart';
import 'package:flutter_wan/common/BuildConfig.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/AppInterceptor.dart';

class ApiService {
  static final baseUrl = "https://www.wanandroid.com/";

  ApiService._internal();

  static ApiService _instance = ApiService._internal();

  factory ApiService.ins() => _instance;

  late Dio _dio;

  init() {
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl, connectTimeout: 15000, receiveTimeout: 15000));
    _dio.interceptors.add(AppInterceptor());
    if (BuildConfig.getCompileMode() == "debug") {
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  getHttpAsync(String action, {Map<String, dynamic>? querys}) async {
    try {
      Response response = await _dio.get(action, queryParameters: querys);
      return resolveResponse(response);
    } on Exception catch (e) {
      print("catch e ${e.toString()}");
      if (e is ApiException)
        throw e;
      else
        throw ApiException(-1, "网络异常");
    }
  }

  postHttpAsync(String action,
      {Map<String, dynamic>? data, Map<String, dynamic>? querys}) async {
    try {
      var response =
          await _dio.post(action, data: data, queryParameters: querys);
      return resolveResponse(response);
    } on Exception catch (e) {
      print("catch e ${e.toString()}");
      if (e is ApiException)
        throw e;
      else
        throw ApiException(-1, "网络异常");
    }
  }

  dynamic resolveResponse(Response response) {
    if (response.statusCode == 200) {
      var res = response.data;
      var code = res["errorCode"];
      var msg = res["errorMsg"];
      var data = res["data"];
      if (code != -1)
        return data;
      else
        throw ApiException(code, msg);
    } else {
      throw ApiException(-1, "网络异常");
    }
  }
}
