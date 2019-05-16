import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mung_flutter/bloc/theme_bloc.dart';
import 'package:mung_flutter/data/net/http_base.dart';
import 'package:mung_flutter/data/net/http_movie.dart';
import 'package:mung_flutter/model/hot_model.dart';
import 'package:mung_flutter/style/base_style.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:mung_flutter/utils/route_util.dart';
import 'package:mung_flutter/utils/ui_util.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainPage> {

  bool _scrollRefreshing = false;
  int _start = 0;
  int _total = -1;
  List<HotSubjectsModel> _hotMovieItems = [];

  _requestData() {

    if (_scrollRefreshing) return;

    setState(() {
      _scrollRefreshing = true;
    });

    HttpMovie.requestMovieHot(_start+1,20)
        .then((result){
          HotModel hotModel = HotModel.fromJson(result);
          if (hotModel.code == CODE_SUCCESS && hotModel.subjects != null) {
            setState(() {
              _scrollRefreshing = false;
              _start = hotModel.start;
              _total = hotModel.total;
              _hotMovieItems.addAll(hotModel.subjects);
            });
          } else {
            setState(() {
              _scrollRefreshing = false;
            });
          }
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
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
                          title: Text("Mung",style: BaseStyle.textStyleWhite(18),),
                          centerTitle: true,
                          actions: <Widget>[ UiUtil.getIconFontButton(0xeafe,(){
                            this._requestData();
                          }) ],
                        ),
                        body: _GridViewWidget(_hotItems),
                      );
                    }
                )
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}

class _BannerWidget extends StatelessWidget {

  final List<HotSubjectsModel> _hotItems;

  _BannerWidget(this._hotItems);

  List<Widget> _getDotView(int activeIndex) {
    int tempIndex = 4;
    return _hotItems.map((model){
      tempIndex = tempIndex - 1;
      return Container(
        width: 16,
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: activeIndex == tempIndex ? WColors.color_ff : WColors.color_66,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    //限制行数和越界问题
    double bannerLeftWidth = UiUtil.getDeviceWidth(context) - 15*2 - 12*3 - 178*0.68;

    return Container(
      height: 200,
      margin: const EdgeInsets.all(15),
      child: Swiper(
        itemCount: _hotItems.length,
        itemBuilder: (BuildContext context,int index){
          HotSubjectsModel _model = _hotItems[index];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).primaryColor
            ),
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: BaseStyle.clipRRectImg(_model.largeImage, 178*0.68, 178, 4)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BaseStyle.limitLineText(bannerLeftWidth, _model.title, BaseStyle.textStyleWhite(16), 1),
                      Row(
                        children: <Widget>[
                          BaseStyle.clipOvalImg(_model.avatarsSmall, 26),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: BaseStyle.limitLineText(bannerLeftWidth - 36 , _model.directorsName, BaseStyle.textStyleWhite(14),1),
                          )
                        ],
                      ),
                      BaseStyle.limitLineText(bannerLeftWidth, '主演: '+_model.castNames, BaseStyle.textStyleWhite(14), 2),
                      BaseStyle.limitLineText(bannerLeftWidth, _model.collectCount.toString()+" 看过" , BaseStyle.textStyleWhite(14), 1),
                      BaseStyle.starWidget(_model.ratingAverage, 20)
                    ],
                  ),
                )
              ],
            ),
          );
        },
        autoplay: true,
        autoplayDelay: 4000,
        duration: 100, //圆角过度很丑，减到人察觉不到的时间差
        pagination: SwiperCustomPagination(
            builder:(BuildContext context, SwiperPluginConfig config){
              return Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: _getDotView(config.activeIndex),
                )
              );
            },
        ),
      ),
    );
  }

}

class _GridViewWidget extends StatelessWidget {

  final List<HotSubjectsModel> _hotItems;

  _GridViewWidget(this._hotItems);

  @override
  Widget build(BuildContext context) {

    double gapWidth = 10;
    double itemWidth = (UiUtil.getDeviceWidth(context) - gapWidth*4)/3;

    return Padding(
      padding: EdgeInsets.all(gapWidth),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: gapWidth,
            crossAxisSpacing: gapWidth,
            childAspectRatio: 3/5
          ),
          itemCount: _hotItems.length,
          itemBuilder: (BuildContext context,int index) {
            HotSubjectsModel model = _hotItems[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,bottom: 0,left: 0,right: 0,
                      child: Image.network(
                        model.largeImage,
                        fit: BoxFit.fill,
                      )
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: itemWidth,
                              child: Text(
                                model.title,
                                textAlign: TextAlign.center,
                                style: BaseStyle.textStyleWhite(12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            BaseStyle.starWidget(model.ratingAverage, 14,true)
                          ]
                        ),
                      )
                  )
                ],
              ),
            );
          }
      ),
    );
  }

}