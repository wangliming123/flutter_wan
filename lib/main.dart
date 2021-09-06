import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/LoginPage.dart';
import 'package:flutter_wan/ui/MainPage.dart';
import 'package:flutter_wan/ui/SplashPage.dart';
import 'package:flutter_wan/ui/pages/discover/KnowledgeInfoPage.dart';
import 'package:flutter_wan/ui/pages/discover/KnowledgeTreePage.dart';
import 'package:flutter_wan/ui/pages/discover/NavigationPage.dart';
import 'package:flutter_wan/ui/pages/discover/ShareArticlePage.dart';
import 'package:flutter_wan/ui/pages/discover/SquarePage.dart';
import 'package:flutter_wan/ui/pages/WebViewPage.dart';
import 'package:flutter_wan/ui/pages/mine/CollectPage.dart';
import 'package:flutter_wan/ui/pages/mine/TodoListPage.dart';
import 'package:flutter_wan/ui/pages/mine/UserSharePage.dart';
import 'package:flutter_wan/util/CommonUtils.dart';

Future<void> main() async {
  runApp(MyApp());
  //设置Android端状态栏透明，状态栏文字默认为黑色
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
  // 强制竖屏
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  ApiService.ins().init();
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SmartRefreshBuilder.buildApp(child: getPlatformApp());
  }

  StatelessWidget getPlatformApp() {
    return ScreenUtilInit(
      designSize: Size(375, 668),
      builder: () => MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: RouteConst.splashPage,
        onGenerateRoute: (settings) {
          return getRoute(settings);
        },
      ),
    );
  }

  PageRoute getRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      RouteConst.splashPage: (_) => SplashPage(),
      RouteConst.loginPage: (_) => LoginPage(),
      RouteConst.mainPage: (_) => MainPage(),
      RouteConst.webView: (_) {
        var webUrl = settings.arguments as WebUrl;
        return WebViewPage(webUrl.url, webUrl.title);
      },
      RouteConst.square: (_) => SquarePage(),
      RouteConst.shareArticle: (_) => ShareArticlePage(),
      RouteConst.knowledgeTree: (_) => KnowledgeTreePage(),
      RouteConst.knowledgeInfo: (_) {
        dynamic map = settings.arguments;
        return KnowledgeInfoPage(knowledge: map["knowledge"], id: map["id"],);
      },
      RouteConst.navigation: (_) => NavigationPage(),

      RouteConst.collect: (_) => CollectPage(),
      RouteConst.userShare: (_) => UserSharePage(),
      RouteConst.todoList: (_) => TodoListPage(),
    };
    WidgetBuilder builder = routes[settings.name] ?? (_) => SplashPage();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
