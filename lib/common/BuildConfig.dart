
class BuildConfig {


  static bool isDebug() {
    bool inDebug = false;
    //Debug模式下,是可以使用断言功能的,但是Profile和Release包下,断言被禁用了
    assert(inDebug = true);
    return inDebug;
  }

  /// 判断编译模式
  static String getCompileMode() {
    const bool isProfile = const bool.fromEnvironment("dart.vm.profile");
    const bool isRelease = const bool.fromEnvironment("dart.vm.product");
    if (isDebug()) {
      return "debug";
    } else if (isProfile) {
      return "profile";
    } else if (isRelease) {
      return "release";
    } else {
      return "unknown";
    }
  }
}