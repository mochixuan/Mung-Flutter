import 'package:mung_flutter/data/net/http_base.dart';

const KEY_APP_ID = "0df993c66c0c636e29ecbb5344252a4a";

class HttpMovie {

  /*正在热映*/
  static const _MOVIE_HOT_URL = "/movie/in_theaters";
  /*电影条目信息*/
  static const _MOVIE_DETAIL_URL = '/movie/subject/';

  static requestMovieHot(int _start,int _count) => HttpBase.baseGetRequest("${_MOVIE_HOT_URL}?start=${_start}&count=${_count}");

  static requestDetailBaseData(String id) => HttpBase.baseGetRequest("${_MOVIE_DETAIL_URL+id}");

  static requestMoviePhotos(String id,int count) => HttpBase.baseGetRequest("${_MOVIE_DETAIL_URL+id}/photos?count=${count}&apikey=${KEY_APP_ID}");

  static requestMovieDiscuss(String id,int start,int count) => HttpBase.baseGetRequest("${_MOVIE_DETAIL_URL+id}/comments?start=${start}&count=${count}&apikey=${KEY_APP_ID}");

  static requestListMovie(String url,int start,int count,String query) => HttpBase.baseGetRequest("${url}?q=${query}start=${start}&count=${count}&apikey=${KEY_APP_ID}");

}