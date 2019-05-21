import 'package:flutter/material.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BaseStyle {

  static TextStyle textStyleWhite(double fontSize,[bool isBold = false]) {
    return TextStyle(fontSize: fontSize,color: WColors.color_ff,fontWeight: isBold ? FontWeight.bold : FontWeight.normal);
  }

  // 带小圆角图片
  static Widget clipRRectImg(url,double width,double height,double border) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(border),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }

  // 圆角图片
  static Widget clipOvalImg(url,double size) {
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.fill,
      ),
    );
  }

  // 行数限制的Text
  static Widget limitLineText(double width,String text, TextStyle textStyle,int maxLines) {
    return Container(
      width: width,
      child: Text(
        text,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      ),
    );
  }

  // 星级
  static Widget starWidgetAndText(double ratingAverage,double size,[bool isCenter = false]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: <Widget>[
        SmoothStarRating(
          allowHalfRating: true,
          starCount: 5,
          rating: ratingAverage/2,
          size: size,
          color: WColors.color_fc3,
          borderColor: WColors.color_e6,
        ),
        Padding(padding: const EdgeInsets.only(left: 10,top: 3),
          child: Text(ratingAverage.toString(),
              style: TextStyle(fontSize: 14, color: WColors.color_fc3)
          ),
        )
      ],
    );
  }

  static Widget starWidget(double ratingAverage,double size) {
    return SmoothStarRating(
      allowHalfRating: true,
      starCount: 5,
      rating: ratingAverage/2,
      size: size,
      color: WColors.color_fc3,
      borderColor: WColors.color_e6,
    );
  }



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

}