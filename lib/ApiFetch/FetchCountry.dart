import 'dart:convert';

import 'package:news_website/Helper/ApiBaseHelper.dart';
import 'package:news_website/Models/CountryModel.dart';

class FetchCountry{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<CountryModel>> fetch_country_list()
  async {
    List<CountryModel> country_list=[];
    var url = "http://65.0.199.38:3000/api/Countries/";
    final response = await _helper.get(url);
    if(response!=null && response.statusCode==200)
    {
      List hh=jsonDecode(response.body);
      hh.forEach((element) {
        CountryModel countryModel=new CountryModel.fromJson(element);
        country_list.add(countryModel);
      });
    }
    return country_list;
  }
}