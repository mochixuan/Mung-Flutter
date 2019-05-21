import 'package:flutter/material.dart';
import 'package:mung_flutter/data/net/http_base.dart';
import 'package:mung_flutter/data/net/http_movie.dart';
import 'package:mung_flutter/style/base_style.dart';
import 'package:mung_flutter/utils/ui_util.dart';
import 'package:mung_flutter/widget/loading_widget.dart';
import 'package:mung_flutter/model/loading_state.dart';
import 'package:mung_flutter/model/detail_base_model.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:mung_flutter/model/stills_model.dart';
import 'package:mung_flutter/model/discuss_model.dart';
import 'package:mung_flutter/widget/loading_footer_widget.dart';
import 'package:mung_flutter/utils/route_util.dart';

class DetailPage extends StatefulWidget {

  final String id;

  DetailPage({@required this.id});

  @override
  State<StatefulWidget> createState() {
    return DetailState(id: this.id);
  }
}

class DetailState extends State<DetailPage> {

  final String id;
  LoadingState _loadingState = LoadingState.Loading;
  LoadingState _stillLoadingState = LoadingState.Loading;
  LoadingState _discussLoadingState = LoadingState.Loading;
  DetailBaseModel _detailBaseModel;
  List<StillItem> _stillItems;
  double _ratingAverage = 0;
  bool _isOpenIntro = false;

  int _discussStart = 0;
  List<DiscussItem> _discussItems = [];
  bool _scrollRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  DetailState({@required this.id});

  @override
  void initState() {
    super.initState();

    _requestBaseData();
    _requestSectionStills();
    _requestDiscussData();

    _scrollController.addListener((){
      // 如果错误要手动单机重新加载
      if (_discussLoadingState != LoadingState.Error &&
          _discussLoadingState != LoadingState.NoMore) {
        double _curHeight = _scrollController.position.pixels;
        double _maxHeight = _scrollController.position.maxScrollExtent;
        if (_curHeight+loadingFooterHeight*0.8 > _maxHeight) {
          this._requestDiscussData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_detailBaseModel == null ||
        _detailBaseModel.code != CODE_SUCCESS) {
      return LoadingWidget(_loadingState,this._requestBaseData);
    }

    return Material(
      color: WColors.color_f5,
      child: Padding(
        padding: EdgeInsets.only(bottom: UiUtil.getSafeBottomPadding(context)),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leading: BaseStyle.getIconFontButton(0xeb09,() => Navigator.pop(context)),
              expandedHeight: 300,
              pinned: true,
              title: Text(_detailBaseModel.title),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  margin: EdgeInsets.only(
                    top: UiUtil.getSafeTopPadding(context)+56,
                    bottom: 28
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      _detailBaseModel.imagesLarge,
                    ),
                  ),
                ),
              ),
            ),
            _baseInfoWidget(),
            _discussWidget(),
            SliverToBoxAdapter(
                child: LoadingFooterWidget(_discussLoadingState,this._requestDiscussData)
            )
          ],
        ),
      ),
    );
  }

  _requestBaseData() {

    setState(() {
      _loadingState = LoadingState.Loading;
    });

    HttpMovie.requestDetailBaseData(this.id)
        .then((result){
          _detailBaseModel = DetailBaseModel.fromJson(result);
          if(_detailBaseModel.code == CODE_SUCCESS) {
            setState(() {
              _loadingState = LoadingState.NoMore;
            });
          } else {
            setState(() {
              _loadingState = LoadingState.Error;
            });
          }
        });
  }

  _requestSectionStills() {

    setState(() {
      _stillLoadingState = LoadingState.Loading;
    });

    HttpMovie.requestMoviePhotos(this.id, 6)
        .then((result){
          StillsModel stillsModel = StillsModel.fromJson(result);
          if (stillsModel.code == CODE_SUCCESS && stillsModel.stillItems != null) {
            setState(() {
              _stillLoadingState = LoadingState.NoMore;
              _stillItems = stillsModel.stillItems;
            });
          } else {
            setState(() {
              _stillLoadingState = LoadingState.Error;
            });
          }
        });
  }

  _requestDiscussData() {

    if (_scrollRefreshing || _discussLoadingState == LoadingState.NoMore) return;

    setState(() {
      _scrollRefreshing = true;
      _discussLoadingState = LoadingState.Loading;
    });

    HttpMovie.requestMovieDiscuss(this.id, _discussStart+1, 8)
      .then((result){
          DiscussModel discussModel = DiscussModel.fromJson(result);
          if (discussModel.code == CODE_SUCCESS && discussModel.discussItems != null) {
            setState(() {
              _scrollRefreshing = false;
              _discussStart = discussModel.start;
              _discussItems.addAll(discussModel.discussItems);
              _loadingState = _discussItems.length != 8 ? LoadingState.NoMore : LoadingState.Loading;
            });
          } else {
            setState(() {
              _scrollRefreshing = false;
              _loadingState = LoadingState.Error;
            });
          }
      });
  }

  SliverToBoxAdapter _baseInfoWidget() {

    double descWidth = UiUtil.getDeviceWidth(context) - 140;
    double filmmakerWidth = (UiUtil.getDeviceWidth(context) - 30)/4;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 基本信息
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BaseStyle.limitLineText(
                            descWidth, _detailBaseModel.title,
                            TextStyle(fontSize: 16,color: WColors.color_66,fontWeight: FontWeight.bold), 1
                        ),
                      ),
                      BaseStyle.limitLineText(descWidth,"${_detailBaseModel.year}/${_detailBaseModel.genres}",TextStyle(fontSize: 13,color: WColors.color_9d),1),
                      BaseStyle.limitLineText(descWidth,"原名: ${_detailBaseModel.originalTitle}",TextStyle(fontSize: 13,color: WColors.color_9d),1),
                      BaseStyle.limitLineText(descWidth,"导演: ${_detailBaseModel.directorsName}",TextStyle(fontSize: 13,color: WColors.color_9d),1),
                      BaseStyle.limitLineText(descWidth,"主演: ${_detailBaseModel.castsName}",TextStyle(fontSize: 13,color: WColors.color_9d),1),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: WColors.color_ff,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("综合评分",style: TextStyle(fontSize: 12,color: WColors.color_9d)),
                        Text(_detailBaseModel.ratingAverage.toString(),style: TextStyle(fontSize: 18,color: WColors.color_66,fontWeight: FontWeight.bold)),
                        BaseStyle.starWidget(_detailBaseModel.ratingAverage, 12),
                        Text("${_detailBaseModel.ratingsCount}人",style: TextStyle(fontSize: 12,color: WColors.color_9d)),
                      ],
                    ),
                  )
                ],
              )
          ),
          Container(
            height: 48,
            margin: const EdgeInsets.only(top: 10,bottom: 20,right: 15,left: 15),
            decoration: BoxDecoration(
                border: Border.all(color: WColors.color_fc3,width: 2),
                borderRadius: BorderRadius.circular(4)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("我来评分",style: TextStyle(color: WColors.color_fc3,fontSize: 16)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: _ratingAverage,
                      size: 24,
                      color: WColors.color_fc3,
                      borderColor: WColors.color_e6,
                      onRatingChanged: (rate) {
                        setState(() {
                          _ratingAverage = rate;
                        });
                      }
                  ),
                )
              ],
            ),
          ),
          Container(height: 2, color: WColors.color_ff),
          Padding(
            padding: const EdgeInsets.only(top: 20,bottom: 10,left: 10,right: 10),
            child: Text("简介",style: TextStyle(fontSize: 14,color: WColors.color_66),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    _detailBaseModel.summary,style:
                    TextStyle(fontSize: 14,color: WColors.color_9d,height: 1.2),
                    maxLines: _isOpenIntro ? 20 : 4,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
                Visibility(
                    visible: !_isOpenIntro,
                    child: Positioned(
                        right: 0,
                        bottom: 0,
                        width: 40,
                        height: 24,
                        child: FlatButton(
                            padding: const EdgeInsets.all(0),
                            color: WColors.color_f5,
                            onPressed: (){
                              setState(() {
                                _isOpenIntro = true;
                              });
                            },
                            child: Text("展开",style: TextStyle(fontSize: 14,height: 1.2,color: Theme.of(context).primaryColor),)
                        )
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
            child: Text("影人",style: TextStyle(fontSize: 14,color: WColors.color_66),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
            child: Row(
              children: _detailBaseModel.castFilmmakerItems
                  .map((item){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          item.large,
                          width: (UiUtil.getDeviceWidth(context)-50)/4,
                          height: 160,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          width: filmmakerWidth,
                          child: Text(
                            item.name,
                            style: TextStyle(fontSize: 12,color: WColors.color_9d),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        )
                      ],
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
            child: Text("剧照",style: TextStyle(fontSize: 14,color: WColors.color_66),),
          ),
          _sectionStillsWidget(),
          Container(
              height: 2,
              color: WColors.color_ff,
              margin: const EdgeInsets.only(top: 10),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text("评论区",style: TextStyle(fontSize: 16,color: WColors.color_9d),),
          )
        ],
      ),
    );
  }

  Widget _sectionStillsWidget() {
    if (_stillItems == null) {
      return Container(
        height: 150,
        child: LoadingWidget(_stillLoadingState, _requestSectionStills),
      );
    }

    List<Widget> widget = [];
    int photoCount = 0;
    if (_stillItems.length > 0) photoCount = _stillItems[0].photoCount;
    for(int i = 0 ; i < _stillItems.length ; i++) {
      widget.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image.network(_stillItems[i].image,fit: BoxFit.fill,width: 220,height: 150,),
            ),
          )
      );
    }
    widget.add(
      FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: (){
            RouteUtil.routeToPhotoDetailPage(context, this.id,photoCount);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              width: 150,
              height: 150,
              color: WColors.color_9d,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("全部剧照",style: TextStyle(fontSize: 14,color: WColors.color_ff),),
                  Container(color: WColors.color_ff,width: 75,height: 1,margin: const EdgeInsets.symmetric(vertical: 4),),
                  Text("${photoCount} 张",style: TextStyle(fontSize: 12,color: WColors.color_ff),),
                ],
              ),
            ),
          )
      )
    );


    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget,
        ),
      ),
    );
  }

  SliverList _discussWidget() {

    return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            DiscussItem discussItem = _discussItems[index];
            return Container(
              color: WColors.color_ff,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: Image.network(
                      discussItem.authorAvatar,
                      width: 36,
                      height: 36,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(discussItem.name,style: TextStyle(fontSize: 12,color: WColors.color_66),),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: BaseStyle.starWidget(discussItem.ratingValue/2, 12),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      IconData(0xe7a7,fontFamily: 'iconfont'),
                                      size: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(discussItem.usefulCount.toString(),style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor),),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Text(discussItem.content,style: TextStyle(
                              fontSize: 14,
                              color: WColors.color_66,
                              height: 1.1,
                            ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(discussItem.createdAt,style: TextStyle(
                                    fontSize: 12,
                                    color: WColors.color_66
                                ),)
                              ],
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            );
          } ,
          childCount: _discussItems.length
        ),
    );
  }

}

