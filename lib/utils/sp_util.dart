import 'package:shared_preferences/shared_preferences.dart';

// 存储主题色
class SPUtil {

  static const _THEME_COLOR_KEY = 'THEME_COLOR_KEY';
  static setThemeColor(int themeColor) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(_THEME_COLOR_KEY,themeColor) ;
  }
  static getThemeColor() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(_THEME_COLOR_KEY);
  }

}