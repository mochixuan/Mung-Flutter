import 'package:flutter/material.dart';
import 'package:banner/banner.dart';

import 'package:mung_flutter/pages/theme_page.dart';

import 'package:mung_flutter/utils/ui_util.dart';
import 'package:mung_flutter/utils/route_util.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff937eff),
          backgroundColor: Color(0xfff5f5f5),
        ),
        // 加Builder的原因是跳转时传递的context系统内部回去一直向上获取MaterialAPP,而这里如果不写context就拿不到MaterialApp的context了
        home: new Builder(
            builder: (context){
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(icon: UiUtil.getIconFontButton(0xeaec,() => RouteUtil.routeToThemePage(context))),
                  title: Text("Mung"),
                  centerTitle: true,
                  actions: <Widget>[ UiUtil.getIconFontButton(0xeafe,(){}) ],
                ),
                body: BannerView(
                  data: [
                    111111111111111,
                    222222222222222,
                    333333333333333,
                    444444444444444
                  ],
                  delayTime: 5,
                  buildShowView: (index,item){
                    return Container(
                      width: 100,
                      height: 100,
                      child: new Text(item.toString()),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 10,
                          )
                      ),
                    );
                  },
                  onBannerClickListener: (index,item){

                  },
                ),
              );
            }
        )
    );
  }
  
}