import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:mung_flutter/model/loading_state.dart';

class LoadingWidget extends StatelessWidget {

  final LoadingState _loadingState;
  final VoidCallback reLoad;

  LoadingWidget(this._loadingState,this.reLoad);

  @override
  Widget build(BuildContext context) {

    if (_loadingState == LoadingState.Error ||
        _loadingState == LoadingState.NoMore) {
      return Container(
        color: WColors.color_e6,
        child: RaisedButton(
          onPressed: () {
            if (_loadingState == LoadingState.Error) this.reLoad();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  IconData(0xe639,fontFamily: 'iconfont'),
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(
                      _loadingState == LoadingState.Error ? "重新加载" : '没有数据',
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
        ),
      );
    }

    return Container(
      color: WColors.color_e6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitPouringHourglass(
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
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