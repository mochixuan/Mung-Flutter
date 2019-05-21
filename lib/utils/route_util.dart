import 'package:flutter/material.dart';
import 'package:mung_flutter/pages/detail_page.dart';
import 'package:mung_flutter/pages/theme_page.dart';
import 'package:mung_flutter/pages/photo_detail_page.dart';
import 'package:mung_flutter/pages/list_page.dart';
import 'package:mung_flutter/pages/search_page.dart';

class RouteUtil {

  static void routeToThemePage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return ThemePage();
            }
        )
    );
  }

  static void routeToDetailPage(BuildContext context,String id) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return DetailPage(id: id);
            }
        )
    );
  }

  static void routeToPhotoDetailPage(BuildContext context, String id,int count) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return PhotoDetailPage(id: id,count: count);
            }
        )
    );
  }

  static void routeToListPage(BuildContext context, String title) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return ListPage(title: title);
            }
        )
    );
  }

  static void routeToSearchPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context){
              return SearchPage();
            }
        )
    );
  }

}