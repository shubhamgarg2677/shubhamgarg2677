import 'dart:convert';

import 'package:news_website/Helper/ApiBaseHelper.dart';
import 'package:news_website/Models/NewsDataModel.dart';

class FetchNews{
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Map<int,Map<int,Map<int,NewsDataModel>>>> fetch_news_list(int country,int category,int limit,int offset)
  async {
    Map<int,NewsDataModel> news_map= {};
    var url = "";
    //http://65.0.199.38:3000/api/users?filter={%22where%22:{%22country%22:40,%22category%22:6},%22limit%22:10,%22skip%22:10}
    if(category==0)
    {
      url="http://65.0.199.38:3000/api/users?filter={%22where%22:{%22country%22:$country},%22limit%22:$limit,%22skip%22:$offset}";
    }
    else{
      url="http://65.0.199.38:3000/api/users?filter={%22where%22:{%22country%22:$country,%22category%22:$category},%22limit%22:$limit,%22skip%22:$offset}";
    }
    final response = await _helper.get(url);
    if(response!=null && response.statusCode==200)
    {
      List hh=jsonDecode(response.body);
      hh.forEach((element) {
        NewsDataModel newsdataModel=new NewsDataModel.fromJson(element);
        news_map.putIfAbsent(newsdataModel.id, () => newsdataModel);
      });
    }
    return {country:{category:news_map}};
  }
}