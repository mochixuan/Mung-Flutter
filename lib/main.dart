import 'package:flutter/material.dart';
import 'package:mung_flutter/bloc/theme_bloc.dart';
import 'package:mung_flutter/pages/main_page.dart';



void main(){

 ThemeBloc _themeBloc = ThemeBloc();

 // bloc init
 final entryPage = ThemeProvider(
     themeBloc: _themeBloc,
     child: StreamBuilder<int>(
         stream: _themeBloc.stream,
         builder: (context,snapshot){
           return MainPage();
         }
     )
 );

 return runApp(entryPage);
}
