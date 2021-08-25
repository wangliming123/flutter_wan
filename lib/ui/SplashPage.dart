import 'package:flutter/cupertino.dart';
import 'package:flutter_wan/util/SpUtils.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.wait(<Future<void>>[], eagerError: true).then((_) async {
      bool isLogin = await SpUtils.getInstance().getBool("is_login");
      if (isLogin) {}
    });
    return Image.asset(
      'images/splash_pic.png',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
  }
}
