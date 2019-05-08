import 'package:flutter/material.dart';
import 'package:mung_flutter/utils/ui_util.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: UiUtil.getIconFontButton(0xeb09,() => Navigator.pop(context))),
        title: Text("主题"),
        centerTitle: true
      ),
      body: new Text("asasas"),
    );
  }
}