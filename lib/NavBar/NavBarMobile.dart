import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_website/Bloc/CategoryBloc.dart';
import 'package:news_website/Helper/ApiBaseHelper.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/NewsWidgets/ShowProgress.dart';
import 'package:news_website/Provider/CategoryProvider.dart';
import 'package:news_website/Utils/AppColor.dart';
import 'package:news_website/Utils/Dimen.dart';
import 'package:provider/provider.dart';
import '../Models/CategoryModel.dart';

class NavBarMobile extends StatelessWidget{

  CategoryBloc _categoryBloc;
  NavBarMobile(this._categoryBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8,right: 8),
      height: 50,
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
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context,index)
                  {
                    return NavbarTabWidget(snapshot.data.data[index],index,context);
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
      // child: FutureBuilder<List<CategoryModel>>(
      //     future: fetch_category_list(),
      //     builder: (context, snapshot) {
      //       if(snapshot.hasData)
      //       {
      //         return ListView.builder(
      //           scrollDirection: Axis.horizontal,
      //           itemCount: snapshot.data.length,
      //           itemBuilder: (context,index)
      //           {
      //             return NavbarTabWidget(snapshot.data[index],index);
      //           },
      //         );
      //       }
      //       else{
      //         return Container(
      //           height: 20,
      //           width: 20,
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     }
      // ),
    );
  }


  Widget NavbarTabWidget(CategoryModel categoryModel ,int index,BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(6),
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return ChoiceChip(
            label: Text(categoryModel.fullName),
            labelStyle: TextStyle(
              fontSize: Dimen.textBodyMobile,
              color: categoryProvider.categoryModel.id==index ? AppColor.white : AppColor.textBlack,
            ),
            selectedColor: AppColor.appColor,
            backgroundColor: AppColor.backGrey,
            selected: categoryProvider.categoryModel.id==index ? true : false,
            onSelected: (bool value) {
              if(value){
                categoryProvider.set_country(categoryModel);
              }
            },
          );
        }
      ),
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
  //   //final response = await http.get(Uri.parse(url));
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

}