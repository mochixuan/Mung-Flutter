import 'package:flutter/material.dart';
import 'package:mung_flutter/data/net/http_base.dart';
import 'package:mung_flutter/data/net/http_movie.dart';
import 'package:mung_flutter/model/loading_state.dart';
import 'package:mung_flutter/style/base_style.dart';
import 'package:mung_flutter/model/stills_model.dart';
import 'package:mung_flutter/widget/loading_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mung_flutter/style/colors.dart';

class PhotoDetailPage extends StatefulWidget {

  final int count;
  final String id;

  PhotoDetailPage({this.id,this.count});

  @override
  State<StatefulWidget> createState() {
    return PhotoDetailState(id: this.id,count: this.count);
  }

}

class PhotoDetailState extends State<PhotoDetailPage> with SingleTickerProviderStateMixin{

  final int count;
  final String id;
  LoadingState _loadingState = LoadingState.Loading;
  List<StillItem> _stillItems = [];
  int _curPage = 1;
  AnimationController _animationController;
  Animation<double> _animation;

  PhotoDetailState({this.id,this.count});

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
    );
    _animation = Tween(begin: 0.0,end: 1.0)
        .animate(_animationController)
        ..addListener((){
          setState(() {});
        });

    _requestData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_stillItems.length == 0) {
      return LoadingWidget(_loadingState,this._requestData);
    }

    return Scaffold(
      appBar: AppBar(
        leading: BaseStyle.getIconFontButton(0xeb09,() => Navigator.pop(context)),
        title: Text("${this._curPage}/${_stillItems.length}",style: BaseStyle.textStyleWhite(18)),
        centerTitle: false,
      ),
      body: Transform.scale(
        scale: _animation.value,
        child: Container(
          child: PageView.builder(
              itemCount: _stillItems.length,
              onPageChanged: (int curPage) {
                setState(() {
                  _curPage = _curPage+1;
                });
              },
              itemBuilder: (BuildContext context,int index){
                return PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: WColors.color_f5,
                    ),
                    imageProvider: NetworkImage(_stillItems[index].image,)
                );
              }
          ),
        )
      ),
    );
  }

  _requestData() {

    setState(() {
      _loadingState = LoadingState.Loading;
    });

    HttpMovie.requestMoviePhotos(this.id, this.count)
        .then((result){
      StillsModel stillsModel = StillsModel.fromJson(result);
      if (stillsModel.code == CODE_SUCCESS && stillsModel.stillItems != null) {
        setState(() {
          _loadingState = LoadingState.Loading;
          _stillItems = stillsModel.stillItems;
        });
        _animationController.forward();
      } else {
        setState(() {
          _loadingState = LoadingState.Error;
        });
      }
    });
  }

}