import 'package:flutter/material.dart';

class UiUtil {

  // IconFont 按钮统一管理
  static Widget getIconFontButton(iconFontData,_onPressed) {
    return IconButton(
        icon: Icon(
          IconData(iconFontData,fontFamily: 'iconfont'),
          size: 28,
        ),
        color: Color(0xffffffff),
        onPressed: _onPressed
    );
  }

  static double getSafeBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

}