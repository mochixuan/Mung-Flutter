import 'package:flutter/material.dart';
import 'package:mung_flutter/model/loading_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const loadingFooterHeight = 48.0;

class LoadingFooterWidget extends StatelessWidget {

  final LoadingState _loadingState;
  final VoidCallback reLoad;

  LoadingFooterWidget(this._loadingState,this.reLoad);

  @override
  Widget build(BuildContext context) {

    if (_loadingState == LoadingState.Error ||
        _loadingState == LoadingState.NoMore) {

      return Container(
        height: loadingFooterHeight,
        child: FlatButton(
          onPressed: () {
            if (_loadingState == LoadingState.Error) this.reLoad();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                child: Icon(
                  IconData(0xe639,fontFamily: 'iconfont'),
                  size: 36,
                  color: Theme.of(context).primaryColor,
                ),
                visible: _loadingState == LoadingState.Error,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                    _loadingState == LoadingState.Error ? "重新加载" : "没有更多了～",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      height: loadingFooterHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitPouringHourglass(
            color: Theme.of(context).primaryColor,
            size: 36,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text("飞速加载中",style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
            )),
          )
        ],
      ),
    );

  }

}