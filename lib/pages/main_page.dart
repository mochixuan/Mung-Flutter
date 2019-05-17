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
import 'package:mung_flutter/widget/loading_widget.dart';
import 'package:mung_flutter/model/loading_state.dart';
import 'package:mung_flutter/widget/loading_footer_widget.dart';

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
  final double _gridGapWidth = 10;
  LoadingState _loadingState = LoadingState.Loading;
  final ScrollController _scrollController = ScrollController();

  _requestData() {

    if (_scrollRefreshing || _loadingState == LoadingState.NoMore) return;
    
    setState(() {
      _loadingState = LoadingState.Loading;
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
              _loadingState = hotModel.subjects.length != 20 ? LoadingState.NoMore : LoadingState.Loading;
              _hotMovieItems.addAll(hotModel.subjects);
            });
          } else {
            setState(() {
              _scrollRefreshing = false;
              _loadingState = LoadingState.Error;
            });
          }
        });
  }

  @override
  void initState() {
    super.initState();

    this._requestData();

    _scrollController.addListener((){
      // 如果错误要手动单机重新加载
      if (_loadingState != LoadingState.Error &&
          _loadingState != LoadingState.NoMore) {
        double _curHeight = _scrollController.position.pixels;
        double _maxHeight = _scrollController.position.maxScrollExtent;
        if (_curHeight+loadingFooterHeight*0.8 > _maxHeight) {
          this._requestData();
        }
      }
    });
  }

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
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: BaseStyle.getIconFontButton(
                          0xeaec, () => RouteUtil.routeToThemePage(context)),
                      title: Text("Mung", style: BaseStyle.textStyleWhite(18),),
                      centerTitle: true,
                      actions: <Widget>[ BaseStyle.getIconFontButton(0xeafe, () {
                          this._requestData();
                        })
                      ],
                    ),
                    body: _hotMovieItems.length == 0 ?
                      LoadingWidget(_loadingState,this._requestData):
                      Padding(
                          padding: EdgeInsets.only(
                            left: _gridGapWidth,
                            right: _gridGapWidth,
                            top: _gridGapWidth,
                            bottom: UiUtil.getSafeBottomPadding(context)
                          ),
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: _BannerWidget(_hotMovieItems.take(4).toList()),
                            ),
                            _getGridViewWidget(context, _hotMovieItems.skip(4).toList()),
                            SliverToBoxAdapter(
                              child: LoadingFooterWidget(_loadingState,this._requestData)
                            )
                          ],
                        ),
                      ),
                  );
                }
              )
            );
          }
        )
    );
  }

  @override
  void dispose() {
    ThemeProvider.of(context).dispose();
    _scrollController.dispose();
    super.dispose();
  }

  SliverGrid _getGridViewWidget(BuildContext context, List<HotSubjectsModel> _hotItems) {

    double itemWidth = (UiUtil.getDeviceWidth(context) - _gridGapWidth*4)/3;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: _gridGapWidth,
          crossAxisSpacing: _gridGapWidth,
          childAspectRatio: 3/5
      ),

      delegate: SliverChildBuilderDelegate((context,index){

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
      },childCount: _hotItems.length),
    );
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
    double bannerLeftWidth = UiUtil.getDeviceWidth(context) - 10*2 - 12*3 - 178*0.68;

    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 10),
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