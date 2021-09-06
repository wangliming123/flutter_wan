
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {

  static SpUtils? _mSp;

  SpUtils._ins();

  static SpUtils getInstance() {
    if (_mSp == null) {
      _mSp = SpUtils._ins();
    }
    return _mSp!;
  }

  SharedPreferences? prefs;
  initPrefs() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  putString(String key, String value) async {
    await initPrefs();
    prefs?.setString(key, value);
  }

  getString(String key) async {
    await initPrefs();
    return prefs?.getString(key);
  }

  String? getStringAlways(String key) {
    return prefs?.getString(key);
  }

  removeData(String key) async {
    await initPrefs();
    return prefs?.remove(key);
  }

  putInt(String key, int value) async {
    await initPrefs();
    prefs?.setInt(key, value);
  }

  getInt(String key) async {
    await initPrefs();
    return prefs?.getInt(key);
  }

  int? getIntAlways(String key) {
    return prefs?.getInt(key);
  }

  putDouble(String key, double value) async {
    await initPrefs();
    prefs?.setDouble(key, value);
  }

  getDouble(String key) async {
    await initPrefs();
    return prefs?.getDouble(key);
  }

  double? getDoubleAlways(String key) {
    return prefs?.getDouble(key);
  }

  putBool(String key, bool value) async {
    await initPrefs();
    prefs?.setBool(key, value);
  }

  getBool(String key) async {
    await initPrefs();
    return prefs?.getBool(key);
  }

  bool? getBoolAlways(String key) {
    return prefs?.getBool(key);
  }

}