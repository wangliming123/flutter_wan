import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wan/ui/SplashPage.dart';
import 'package:flutter_wan/util/CommonUtils.dart';

Future<void> main() async {
  // 强制竖屏
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SmartRefreshBuilder.buildApp(child: getPlatformApp());

  }

  StatefulWidget getPlatformApp() {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      home: SplashPage(),
    );
  }
}

