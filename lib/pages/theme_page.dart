import 'package:flutter/material.dart';
import 'package:mung_flutter/data/const/constant.dart';
import 'package:mung_flutter/utils/ui_util.dart';
import 'package:mung_flutter/bloc/theme_bloc.dart';
import 'package:mung_flutter/style/colors.dart';

class ThemePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // 间隙
    const _gridSpacing = 8.0;

    return Scaffold(

      appBar: AppBar(
        leading: UiUtil.getIconFontButton(0xeb09,() => Navigator.pop(context)),
        title: Text("主题",style: TextStyle(color: WColors.color_ff)),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(_gridSpacing),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 5/6,
              crossAxisSpacing: _gridSpacing,
              mainAxisSpacing: _gridSpacing,
              crossAxisCount: 3,
            ),
            itemCount: Constant.ThemeItems.length,
            itemBuilder: (context,index) {

              final _themeModel = Constant.ThemeItems[index];

              return FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  ThemeProvider.of(context).changeTheme(_themeModel['color']);
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(_themeModel['color']),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(4, 4),
                                topRight: Radius.elliptical(4, 4)
                            )
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      color: WColors.color_ff,
                      child: Text(
                        _themeModel['name'],
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color(_themeModel['color']),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}