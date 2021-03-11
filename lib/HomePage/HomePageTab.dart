import 'package:flutter/material.dart';
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/NavBar/NavBarTab.dart';
import 'package:news_website/Content/NewsContent.dart';
import '../Header/NavBarHeader.dart';

class HomePageTab extends StatefulWidget{
  CategoryBloc _categoryBloc;
  HomePageTab(this._categoryBloc);

  @override
  State<StatefulWidget> createState() {
    return HomePageTabState();
  }
}

class HomePageTabState extends State<HomePageTab>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavBarHeader(),
            Flexible(
                child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: NavBarTab(widget._categoryBloc),
                    ),
                    Expanded(
                    flex: 4,
                    child: NewsContent(widget._categoryBloc),
                    ),
                ],
              ),
            ),
          ],
        ),
        );
  }

}