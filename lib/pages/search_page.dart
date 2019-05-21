import 'package:flutter/material.dart';
import 'package:mung_flutter/style/base_style.dart';
import 'package:mung_flutter/data/const/constant.dart';
import 'package:mung_flutter/utils/ui_util.dart';
import 'package:mung_flutter/style/colors.dart';
import 'package:mung_flutter/utils/route_util.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchPage> {

  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final recommendWidth = UiUtil.getDeviceWidth(context)/4;

    return Scaffold(
      appBar: AppBar(
        leading: BaseStyle.getIconFontButton(0xeb09,() => Navigator.pop(context)),
        title: Container(
          height: 40,
          child: TextField(
            autofocus: true,
            controller: _inputController,
            decoration: InputDecoration(
                hintText: "演员/电影名/类型/关键字",
                hintStyle: TextStyle(fontSize: 14,color: WColors.color_9d),
                fillColor: WColors.color_ff,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            ),
            maxLines: 1,
            cursorColor: Theme.of(context).primaryColor,
            style: TextStyle(fontSize: 14,color: WColors.color_66),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[BaseStyle.getIconFontButton(0xeafe, _searchRequest)],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Wrap(
          children: Constant.RecommendItems.map((item){
            return Container(
              width: recommendWidth,
              height: 50,
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: (){
                      FocusScope.of(context).requestFocus(FocusNode()); // 取消键盘
                      _inputController.value = TextEditingValue(text: item);
                      _searchRequest();
                    },
                    color: WColors.color_ff,
                    child: Text(item,style: TextStyle(fontSize: 16,color: WColors.color_9d))
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _searchRequest() {
    final String text = _inputController.value.text;
    if (text.length == 0) {
      return;
    }
    RouteUtil.routeToListPage(context, text);
  }

}