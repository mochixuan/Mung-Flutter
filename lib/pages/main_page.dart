import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mung_flutter/bloc/theme_bloc.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:mung_flutter/utils/route_util.dart';
import 'package:mung_flutter/utils/ui_util.dart';

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // 有个时间差，就是执行顺序问题
    ThemeBloc _themeBloc = ThemeBloc();
    return ThemeProvider(
      themeBloc: _themeBloc,
      child: StreamBuilder<int>(
          stream: _themeBloc.stream,
          builder: (context,snapshot) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Color(_themeBloc.themeColor), // 主题色
                  backgroundColor: WColors.color_f5,
                ),
                // 加Builder的原因是跳转时传递的context系统内部回去一直向上获取MaterialAPP,而这里如果不写context就拿不到MaterialApp的context了
                home: Builder(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          leading: UiUtil.getIconFontButton(0xeaec,() => RouteUtil.routeToThemePage(context)),
                          title: Text("Mung",style: TextStyle(color: WColors.color_ff),),
                          centerTitle: true,
                          actions: <Widget>[ UiUtil.getIconFontButton(0xeafe,(){}) ],
                        ),
                        body: _BannerWidget(),
                      );
                    }
                )
            );
          }
      ),
    );
  }
}

class _BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200,
      margin: const EdgeInsets.all(15),
      child: Swiper(
        itemCount: 4,
        itemBuilder: (BuildContext context,int index){
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).primaryColor
            ),
            child: Text(index.toString()),
          );
        },
        autoplay: true,
        autoplayDelay: 3000,
        pagination: SwiperCustomPagination(
            builder:(BuildContext context, SwiperPluginConfig config){
              return Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: config.activeIndex == 3 ? WColors.color_ff : WColors.color_66,
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: config.activeIndex == 2 ? WColors.color_ff : WColors.color_66,
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: config.activeIndex == 1 ? WColors.color_ff : WColors.color_66,
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: config.activeIndex == 0 ? WColors.color_ff : WColors.color_66,
                      ),
                    )
                  ],
                ),
              );
            }
        )
      ),
    );
  }

}