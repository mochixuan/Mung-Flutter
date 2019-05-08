import 'package:flutter/material.dart';
import 'package:mung_flutter/pages/theme_page.dart';

class RouteUtil {

  static void routeToThemePage(BuildContext context) {
    debugPrint('--------------');
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return ThemePage();
            }
        )
    );
  }

}