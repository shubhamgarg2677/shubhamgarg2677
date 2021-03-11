import 'package:flutter/material.dart';
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/Content/NewsContent.dart';
import '../Header/NavBarHeader.dart';
import '../NavBar/NavBarMobile.dart';

class HomePageMobile extends StatefulWidget{
  CategoryBloc _categoryBloc;
  HomePageMobile(this._categoryBloc);

  @override
  State<StatefulWidget> createState() {
    return HomePageMobileState();
  }
}

class HomePageMobileState extends State<HomePageMobile>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavBarHeader(),
            NavBarMobile(widget._categoryBloc),
            Flexible(child: NewsContent(widget._categoryBloc)),
          ],
        ),
        );
  }
  
} 