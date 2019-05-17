import 'package:dio/dio.dart';

// 数据格式太乱,简单处理一下

const _BASE_URL = "https://douban.uieee.com/v2";

const CODE_SUCCESS = 1;   //自定义成功

const _REQUEST_ERROR = -100;    //网络请求错误
const _TIMEOUT_ERROR_CODE = -101; // 网络超时,请重试!
const _INVALID_API_KEY=104; //apikey无线
const _BAD_REQUEST = 400; //请求的地址不存在或者包含不支持的参数
const _UNAUTHORIZED = 401;  //数据未授权
const _FORBIDDEN = 403;  //数据被禁止访问访问
const _NOT_FOUND = 404;  //请求的资源不存在或被删除
const _INTERNAL_SERVER_ERROR = 500;  //内部错误
const _NEED_PERMISSION = 1000;  //数据未授权

class HttpBase {

  static _errorAnalysis(result) {

    if(result == null || result['code'] == null) {
      return {
        "code": _REQUEST_ERROR,
        "error": '网络超时,请重试!',
      };
    }
  
    switch (result['code']) {
      case CODE_SUCCESS:
        result["error"] = "请求成功";
        break;
      case _TIMEOUT_ERROR_CODE:
        result["error"] = "网络超时,请重试!";
        break;
      case _REQUEST_ERROR:
        result["error"] = "网络请求错误";
        break;
      case _INVALID_API_KEY:
        result["error"] = "ApiKey无效了";
        break;
      case _BAD_REQUEST:
        result["error"] = "请求的地址不存在或者包含不支持的参数";
        break;
      case _UNAUTHORIZED:
        result["error"] = "数据未授权";
        break;
      case _FORBIDDEN:
        result["error"] = "数据被禁止访问访问";
        break;
      case _NOT_FOUND:
        result["error"] = "请求的资源不存在或被删除";
        break;
      case _INTERNAL_SERVER_ERROR:
        result["error"] = "内部错误";
        break;
      case _NEED_PERMISSION:
        result["error"] = "数据未授权";
        break;
      default:
        result["error"] = "网络超时,请重试!";
        break;
    }

    return result;
  }

  // 统一数据，统一数据流出格式
  static baseGetRequest(String urlSuffix) async{

    dynamic result;

    try {
      Dio dio = Dio();
      dio.options.baseUrl = _BASE_URL;
      dio.options.connectTimeout = 10000; // 10s
      dio.options.receiveTimeout = 10000; // 10s
      dio.options.receiveTimeout = 10000; // 10s

      Response response = await dio.get(urlSuffix);

      if (response != null && response.statusCode == 200 && response.data != null) {
        result = response.data;
        if (result['code'] == null) result['code'] = CODE_SUCCESS;
      }
    } catch (e) {
      result = null; //清空
    }

    result = _errorAnalysis(result);

    return result;
  }

}