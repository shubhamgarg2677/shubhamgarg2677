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
  int _countryCode=40;
  int _categoryCode=0;
  bool mobile=false;

  ScrollController _scrollController;
  int limit=50;
  Map<int,Map<int,int>> offset_map;
  int offset=0;
  int initial_offset=0;
  bool api_loading=false;
  Map<int,Map<int,Map<int,NewsDataModel>>> news_map;


  @override
  void initState() {
    // TODO: implement initState
    _scrollController=new ScrollController();
    _scrollController.addListener(ListViewListener);
    news_map= {_countryCode:{_categoryCode: {}}};
    offset_map= {_countryCode:{_categoryCode:initial_offset}};
    _newsBloc = new NewsBloc(_countryCode,_categoryCode,limit,offset);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    int cc=context.watch<CountryProvider>().countryModel.id;
    int cgc=context.watch<CategoryProvider>().categoryModel.id;

    if(cc!=_countryCode) {
      _countryCode = cc;
      check_and_hit_api();
    }

    if(cgc!=_categoryCode) {
      _categoryCode = cgc;
      check_and_hit_api();
    }

    super.didChangeDependencies();
  }


  void ListViewListener()
  {
    if(_scrollController.positions.last.maxScrollExtent==_scrollController.offset
        && _scrollController.position.atEdge && !api_loading && news_map[_countryCode][_categoryCode].length>=offset)
    {
      check_and_hit_api();
    }
  }

  void check_and_hit_api()
  {
    int local_offset=initial_offset;
    if(offset_map.containsKey(_countryCode))
    {
      if(offset_map[_countryCode].containsKey(_categoryCode))
      {
        local_offset=offset_map[_countryCode][_categoryCode]+limit;
      }
      else
      {
        offset_map[_countryCode].putIfAbsent(_categoryCode, () => local_offset);
      }
    }
    else
      {
        offset_map= {_countryCode:{_categoryCode:local_offset}};
      }

    if(local_offset>0 && local_offset==offset)
    {}
    else
      {
        offset=local_offset;
        api_loading=true;
        _newsBloc.fetchCountryList(_countryCode,_categoryCode,limit,local_offset);
      }
  }


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context,constraints)
      {
        mobile=constraints.maxWidth<600 ? true : false;
        bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _headingSize= mobile ? Dimen.textHeadMobile : Dimen.textHeadTab;
        double _height= constraints.heightConstraints().maxHeight;

        return StreamBuilder<ApiResponse<Map<int,Map<int,Map<int,NewsDataModel>>>>>(
          stream: _newsBloc.newsListStream,
          builder: (context, snapshot) {
            if(snapshot.data!=null && snapshot.hasData && snapshot.data.data!=null && snapshot.data.data.length>0)
            {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return ShowProgress();
                  break;
                case Status.COMPLETED:
                  if(news_map.containsKey(snapshot.data.data.keys.first))
                  {
                    if(news_map[snapshot.data.data.keys.first].containsKey(snapshot.data.data.values.first.keys.first))
                    {
                      news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].addAll(snapshot.data.data.values.first.values.first);
                    }
                    else
                    {
                      news_map[snapshot.data.data.keys.first].putIfAbsent(snapshot.data.data.values.first.keys.first, () => snapshot.data.data.values.first.values.first);
                    }
                    //news_map[snapshot.data.data.keys.first].addAll(snapshot.data.data.values.first);
                  }
                  else
                    {
                      news_map.putIfAbsent(snapshot.data.data.keys.first, () => snapshot.data.data.values.first);
                    }
                  print(_categoryCode);
                  api_loading=false;
                  return StreamBuilder<ApiResponse<List<CategoryModel>>>(
                      stream: widget._categoryBloc.categoryListStream,
                      builder: (context, snapshot1) {
                        return CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
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
                            SliverPadding(padding: EdgeInsets.all(mobile?6:10),),
                            news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].length>1
                                ? Top_layer(news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(0,2),snapshot1.hasData
                                ? snapshot1.data.data : [])
                                : SliverPadding(padding: EdgeInsets.all(1),),

                            SliverPadding(padding: EdgeInsets.all(mobile?6:10),),

                            news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].length>5
                                ? Top_column_layer(
                                mobile ? news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(2,4)
                                    : news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(2,5),
                                snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                            SliverPadding(padding: EdgeInsets.all(mobile?6:10),),

                            news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].length>7
                                ? Middle_layer(
                                mobile ? news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(4,6)
                                    : news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(5,7),
                                snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),

                            SliverPadding(padding: EdgeInsets.all(mobile?6:10),),

                            news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].length>8
                                ? News_list(
                                mobile ? news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(6)
                                    : news_map[snapshot.data.data.keys.first][snapshot.data.data.values.first.keys.first].values.toList().sublist(7),
                                snapshot1.hasData ? snapshot1.data.data : []) : SliverPadding(padding: EdgeInsets.all(1),),


                          ],
                        );
                      }
                  );
                  break;
                case Status.ERROR:
                  return ShowProgress();
                  break;
              }
            }
            return ShowProgress();

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
          crossAxisCount: mobile ? 1 : 2,
          childAspectRatio: mobile ? 2 : 2,
          mainAxisSpacing: mobile ? 6 : 10,
          crossAxisSpacing: mobile ? 6 : 10,
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
        crossAxisCount: mobile ? 2 : 3,
        childAspectRatio: mobile ? 0.75 : 1,
        mainAxisSpacing: mobile ? 6 : 10,
        crossAxisSpacing: mobile ? 6 : 10,
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
        crossAxisCount: mobile ? 1 : 2,
        childAspectRatio: mobile ? 2 : 2,
        mainAxisSpacing: mobile ? 6 : 10,
        crossAxisSpacing: mobile ? 6 : 10,
      ),
    );

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
        crossAxisCount: mobile ? 1 : 2,
        childAspectRatio: mobile ? 2 : 2,
        mainAxisSpacing: mobile ? 6 : 10,
        crossAxisSpacing: mobile ? 6 : 10,
      ),
    );
  }


}