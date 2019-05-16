import 'package:mung_flutter/data/net/http_base.dart';

class HttpMovie {

  /*正在热映*/
  static const _MOVIE_HOT_URL = "/movie/in_theaters";
  /*电影条目信息*/
  static const _MOVIE_DETAIL_URL = '/movie/subject/';

  static requestMovieHot(int _start,int _count) => HttpBase.baseGetRequest("${_MOVIE_HOT_URL}?start=${_start}&count=${_count}");

}