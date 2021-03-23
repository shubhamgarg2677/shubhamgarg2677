import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/Helper/ApiBaseHelper.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/Models/NewsDataModel.dart';
import 'package:http/http.dart' as http;
import 'package:news_website/NewsWidgets/ShowProgress.dart';
import 'NavBarItem.dart';
import '../Utils/Dimen.dart';

class NavBarTab extends StatelessWidget{
  CategoryBloc _categoryBloc;
  NavBarTab(this._categoryBloc);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context,constraints)
      {
        bool mobile=constraints.maxWidth<600 ? true : false;
        bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _logoSize= mobile 
                            ? Dimen.logoSizeMob : Dimen.logoSizeTab; 
        double _height= constraints.heightConstraints().maxHeight;

        return Container(
          //height: _height - _logoSize -32,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top:8,),
          // child: FutureBuilder<List<CategoryModel>>(
          //   future: fetch_category_list(),
          //   builder: (context, snapshot) {
          //     if(snapshot.hasData)
          //     {
          //       return ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context,index)
          //         {
          //           return NavBarWidget(snapshot.data[index],index);
          //         },
          //       );
          //     }
          //     else{
          //       return Container(
          //           height: 20,
          //           width: 20,
          //           child: CircularProgressIndicator(),
          //       );
          //     }
          //   }
          // ),
          child: StreamBuilder<ApiResponse<List<CategoryModel>>>(
            stream: _categoryBloc.categoryListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return ShowProgress();
                    break;
                  case Status.COMPLETED:
                    return ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context,index)
                      {
                        return NavBarWidget(snapshot.data.data,index);
                      },
                    );
                    break;
                  case Status.ERROR:
                    return ShowProgress();
                    break;
                }
              }
              return Container();
            },
          ),
        );
      },
      );
  }

  // Future<List<CategoryModel>> fetch_category_list()
  // async {
  //   List<CategoryModel> cateogry_list=[];
  //   CategoryModel categoryModel=new CategoryModel();
  //   categoryModel.fullName="Home";
  //   categoryModel.id=0;
  //   categoryModel.shortName="Home";
  //   cateogry_list.add(categoryModel);
  //   var url = "http://65.0.199.38:3000/api/Categories";
  //   final response = await ApiBaseHelper().get(url);
  //   if(response!=null && response.statusCode==200)
  //   {
  //     List hh=jsonDecode(response.body);
  //     hh.forEach((element) {
  //       CategoryModel categoryModel=new CategoryModel.fromJson(element);
  //       // categoryModel.fullName=element["fullName"];
  //       // categoryModel.id=element["id"];
  //       // categoryModel.shortName=element["shortName"];
  //       cateogry_list.add(categoryModel);
  //     });
  //   }
  //   return cateogry_list;
  // }

  Widget NavBarWidget(List<CategoryModel> categoryModelList, int index)
  {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NavBarItem(return_icon(index+1), categoryModelList, index),
        SizedBox(height: 20,),
      ],
    );
  }

  IconData return_icon(int id)
  {
    switch(id)
    {
      case 0:
        return Icons.home_filled;
      case 1:
        return Icons.business_center_sharp;
      case 2:
        return Icons.videogame_asset;
      case 3:
        return Icons.gamepad_rounded;
      case 4:
        return Icons.healing;
      case 5:
        return Icons.science;
      case 6:
        return Icons.sports;
      case 7:
        return Icons.biotech_rounded;
      default:
        return Icons.gamepad_rounded;
    }
  }

}