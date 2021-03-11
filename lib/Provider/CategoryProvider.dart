import 'package:flutter/material.dart';
import 'package:news_website/Models/CategoryModel.dart';

class CategoryProvider extends ChangeNotifier
{
  CategoryModel _categoryModel = new CategoryModel.initializeModel();


  CategoryModel get categoryModel => _categoryModel;

  void set_country(CategoryModel categoryModel)
  {
    _categoryModel=categoryModel;
    notifyListeners();
  }
}