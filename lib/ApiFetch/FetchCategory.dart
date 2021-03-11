import 'dart:convert';

import 'package:news_website/Helper/ApiBaseHelper.dart';
import 'package:news_website/Models/CategoryModel.dart';

class FetchCategory
{
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<CategoryModel>> fetch_category_list()
  async {
    List<CategoryModel> cateogry_list=[];
    CategoryModel categoryModel=new CategoryModel();
    categoryModel.fullName="Home";
    categoryModel.id=0;
    categoryModel.shortName="Home";
    cateogry_list.add(categoryModel);
    var url = "http://65.0.199.38:3000/api/Categories";
    final response = await _helper.get(url);
    if(response!=null && response.statusCode==200)
    {
      List hh=jsonDecode(response.body);
      hh.forEach((element) {
        CategoryModel categoryModel=new CategoryModel.fromJson(element);
        cateogry_list.add(categoryModel);
      });
    }
    return cateogry_list;
  }

}