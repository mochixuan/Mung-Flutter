import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mung_flutter/utils/sp_util.dart';
import 'package:mung_flutter/data/const/constant.dart';

class ThemeBloc {

  int _themeColor = 0xffffffff;
  final _controller = BehaviorSubject<int>();

  ThemeBloc() {
    _initThemeColor();
  }

  _initThemeColor() async {
    int preThemeColor = await SPUtil.getThemeColor();
    if (preThemeColor == null) {
      preThemeColor = Constant.ThemeItems[0]['color'];
    }
    changeTheme(preThemeColor);
  }

  ValueObservable<int> get stream => _controller.stream;

  int get themeColor => _themeColor;

  changeTheme(int themeColor) {
    _themeColor = themeColor;
    _controller.add(themeColor);
    SPUtil.setThemeColor(themeColor); //存储数据
  }

  void dispose() {
    _controller.close();
  }

}

class ThemeProvider extends InheritedWidget {

  final ThemeBloc themeBloc;

  ThemeProvider({@required Widget child,@required ThemeBloc themeBloc})
      : themeBloc = themeBloc , super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ThemeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ThemeProvider) as ThemeProvider).themeBloc;

}