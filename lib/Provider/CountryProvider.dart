import 'package:flutter/material.dart';
import 'package:news_website/Models/CountryModel.dart';

class CountryProvider extends ChangeNotifier
{
  CountryModel _countryModel = new CountryModel.initializeModel();


  CountryModel get countryModel => _countryModel;

  void set_country(CountryModel countryModel)
  {
    _countryModel=countryModel;
    notifyListeners();
  }
}