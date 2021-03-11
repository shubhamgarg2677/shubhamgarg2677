import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/NewsWidgets/NewsWidgetElementColumn.dart';
import 'package:news_website/NewsWidgets/NewsWidgetElementHorizontal.dart';
import 'package:news_website/NewsWidgets/ShowProgress.dart';
import 'package:news_website/Utils/AppColor.dart';
import 'package:news_website/Utils/Dimen.dart';

import '../Bloc/NewsBloc.dart';
import '../Bloc/NewsBloc.dart';
import '../Helper/ApiResponse.dart';
import '../Models/NewsDataModel.dart';
import '../Provider/CategoryProvider.dart';
import '../Provider/CountryProvider.dart';
import '../Provider/CountryProvider.dart';
import 'package:provider/provider.dart';

class NewsContent extends StatefulWidget{
  CategoryBloc _categoryBloc;
  NewsContent(this._categoryBloc);
  @override
  State<StatefulWidget> createState() {
    return NewsContentState();
  }
}

class NewsContentState  extends State<NewsContent>{
  NewsBloc _newsBloc;
  int _countryCode;
  int _categoryCode;
  bool mobile=false;
  @override
  Widget build(BuildContext context) {
    _countryCode = context.watch<CountryProvider>().countryModel.id;
    _categoryCode = context.watch<CategoryProvider>().categoryModel.id;
    _newsBloc = new NewsBloc(_countryCode,_categoryCode,20,20);
    return LayoutBuilder(
      builder: (context,constraints)
      {
        mobile=constraints.maxWidth<600 ? true : false;
        bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _headingSize= mobile ? Dimen.textHeadMobile : Dimen.textHeadTab;
        double _height= constraints.heightConstraints().maxHeight;
        return StreamBuilder<ApiResponse<List<NewsDataModel>>>(
          stream: _newsBloc.newsListStream,
          builder: (context, snapshot) {
            if(snapshot.data!=null)
            {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Container(
                    height: 20,
                    width: 20,
                    child: ShowProgress(),
                  );
                  break;
                case Status.COMPLETED:
                  return StreamBuilder<ApiResponse<List<CategoryModel>>>(
                    stream: widget._categoryBloc.categoryListStream,
                    builder: (context, snapshot1) {
                      return CustomScrollView(
                        shrinkWrap: true,
                        slivers: [

                          SliverToBoxAdapter(
                            child: Container(
                              height: _headingSize+8,
                              margin: EdgeInsets.only(left:12,top:20,bottom: 12,),
                              child: Text(
                                "Top Headlines",
                                style: TextStyle(
                                  fontSize: _headingSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textBlack,
                                ),
                              ),
                            ),
                          ),

                          snapshot.data.data.length>1 ? Top_layer(snapshot.data.data.sublist(0,2),snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                          snapshot.data.data.length>5 ? Top_column_layer(snapshot.data.data.sublist(2,5),snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                          snapshot.data.data.length>7 ? Middle_layer(snapshot.data.data.sublist(5,7),snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                          snapshot.data.data.length>8 ? News_list(snapshot.data.data.sublist(7),snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                        ],
                      );
                    }
                  );
                  break;
                case Status.ERROR:
                  return Container(
                    height: 20,
                    width: 20,
                    child: ShowProgress(),
                  );
                  break;
              }
            }
            return Container();

          }
        );
      },
      );
  }


  Widget Top_layer(List<NewsDataModel> news_list,List<CategoryModel> category_list)
  {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
             return NewsWidgetElementHorizontal(news_list[index],category_list);
          },
          childCount: news_list.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: mobile ? 1.50 : 2,
        ),
    );
    // return SliverGrid.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: mobile ? 1.50 : 2,
    //   children: [
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     //NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //   ],
    // );
  }

  Widget Top_column_layer(List<NewsDataModel> news_list,List<CategoryModel> category_list)
  {

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return NewsWidgetElementColumn(news_list[index],category_list);
        },
        childCount: news_list.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: mobile ? 0.60 : 1,
      ),
    );

    // return SliverGrid.count(
    //   crossAxisCount: 3,
    //   childAspectRatio: mobile ? 0.60 : 1,
    //   children: [
    //     NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //   ],
    // );
  }

  Widget Middle_layer(List<NewsDataModel> news_list,List<CategoryModel> category_list)
  {

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return NewsWidgetElementHorizontal(news_list[index],category_list);
        },
        childCount: news_list.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: mobile ? 1.50 : 2,
      ),
    );

    // return  SliverGrid.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: mobile ? 1.75 : 2,
    //   children: [
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //   ],
    // );
  }

  Widget News_list(List<NewsDataModel> news_list,List<CategoryModel> category_list)
  {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return NewsWidgetElementHorizontal(news_list[index],category_list);
        },
        childCount: news_list.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: mobile ? 1.50 : 2,
      ),
    );

    // return SliverGrid.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: mobile ? 1.75 : 2,
    //   children: [
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     NewsWidgetElementHorizontal("", "_bodyLine", "_headLine", "_tagLine"),
    //     //NewsWidgetElementColumn("", "_bodyLine", "_headLine", "_tagLine"),
    //   ],
    // );
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }
}