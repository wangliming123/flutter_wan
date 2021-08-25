import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/ui/LoginPage.dart';
import 'package:flutter_wan/ui/SplashPage.dart';
import 'package:flutter_wan/util/CommonUtils.dart';

Future<void> main() async {
  // 强制竖屏
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  ApiService.ins().init();
  runApp(MyApp());
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
    var routes = <String, WidgetBuilder> {
      RouteConst.splashPage: (_) => SplashPage(),
      RouteConst.loginPage: (_) => LoginPage(),
    };
    WidgetBuilder builder = routes[settings.name] ?? (_) => SplashPage();
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
