import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/Provider/CategoryProvider.dart';
import 'package:news_website/Provider/CountryProvider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'HomePageMobile.dart';
import 'HomePageTab.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  CategoryBloc _categoryBloc;

  @override
  void initState() {
    _categoryBloc=CategoryBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> CountryProvider()),
        ChangeNotifierProvider(create: (context)=> CategoryProvider()),
      ],
      child: Scaffold(
        body: ScreenTypeLayout(
        mobile: HomePageMobile(_categoryBloc),
        tablet: HomePageTab(_categoryBloc),
      ),
      ),
    );
  }

}