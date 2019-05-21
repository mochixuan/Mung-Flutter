import 'package:flutter/material.dart';
import 'package:mung_flutter/model/list_model.dart';
import 'package:mung_flutter/style/base_style.dart';
import 'package:mung_flutter/utils/ui_util.dart';
import 'package:mung_flutter/widget/loading_widget.dart';
import 'package:mung_flutter/widget/loading_footer_widget.dart';
import 'package:mung_flutter/model/loading_state.dart';
import 'package:mung_flutter/data/net/http_movie.dart';
import 'package:mung_flutter/data/net/http_base.dart';
import 'package:mung_flutter/data/const/constant.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:mung_flutter/utils/route_util.dart';

class ListPage extends StatefulWidget {
  final String title;

  ListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return ListState(title: this.title);
  }
}

class ListState extends State<ListPage> {

  final String title;
  LoadingState _loadingState = LoadingState.Loading;
  List<ListItem> _listItems = [];
  int _start = 0;
  bool _scrollRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  ListState({this.title});

  _requestData() {

    if (_scrollRefreshing || _loadingState == LoadingState.NoMore) return;

    setState(() {
      _loadingState = LoadingState.Loading;
      _scrollRefreshing = true;
    });

    String url = "";
    if (this.title == Constant.CateItems[0]['title']) {
      url = "/movie/top250";
    } else if (this.title == Constant.CateItems[1]['title']) {
      url = "/movie/weekly";
    } else if (this.title == Constant.CateItems[2]['title']) {
      url = "/movie/us_box";
    } else if (this.title == Constant.CateItems[3]['title']) {
      url = "/movie/new_movies";
    } else {
      url = "/movie/search";
    }

    HttpMovie.requestListMovie(url, _start + 1, 16, this.title)
      .then((result){
          ListModel listModel = ListModel.fromJson(result);
          if (listModel.code == CODE_SUCCESS && listModel.listItems != null) {
            setState(() {
              _scrollRefreshing = false;
              _start = _start + 1; //由于数据可能会为空自己处理
              _loadingState = listModel.listItems.length != 16 ? LoadingState.NoMore : LoadingState.Loading;
              _listItems.addAll(listModel.listItems);
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
    _requestData();

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

    double leftTextWidth = UiUtil.getDeviceWidth(context) - 140;

    return Scaffold(
      appBar: AppBar(
        leading: BaseStyle.getIconFontButton(0xeb09,() => Navigator.pop(context)),
        title: Text(this.title,style: BaseStyle.textStyleWhite(18)),
        centerTitle: true,
      ),
      body: _listItems.length == 0 ?
          LoadingWidget(_loadingState, _requestData) :
          Padding(
            padding: EdgeInsets.only(bottom: UiUtil.getSafeBottomPadding(context)),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context,index){
                        ListItem item = _listItems[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                                padding: const EdgeInsets.all(0),
                                color: WColors.color_ff,
                                onPressed: (){
                                  RouteUtil.routeToDetailPage(context, item.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 200,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          item.largeImage,
                                          width: 96,
                                          height: 155,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            BaseStyle.limitLineText(leftTextWidth, item.title, TextStyle(fontSize: 16,color: WColors.color_66), 1),
                                            BaseStyle.limitLineText(leftTextWidth, '导演: '+item.directorsName, TextStyle(fontSize: 14,color: WColors.color_9d), 1),
                                            BaseStyle.limitLineText(leftTextWidth, '主演: '+item.castNames, TextStyle(fontSize: 14,color: WColors.color_9d), 2),
                                            Text(item.year,style: TextStyle(fontSize: 14,color: WColors.color_9d)),
                                            BaseStyle.starWidgetAndText(item.ratingAverage, 14)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ),
                            Container(height: 2)
                          ],
                        );
                      },
                      childCount: _listItems.length,
                    ),

                ),
                SliverToBoxAdapter(
                    child: LoadingFooterWidget(_loadingState,this._requestData)
                )
              ],
            ),
          )
    );
  }

}