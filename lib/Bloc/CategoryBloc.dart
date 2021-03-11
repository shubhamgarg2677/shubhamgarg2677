import 'dart:async';

import 'package:news_website/ApiFetch/FetchCategory.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc{

  FetchCategory _fetchCategory;

  StreamController _categoryListController;

  StreamSink<ApiResponse<List<CategoryModel>>> get categoryListSink =>
      _categoryListController.sink;

  Stream<ApiResponse<List<CategoryModel>>> get categoryListStream =>
      _categoryListController.stream;

  CategoryBloc()
  {
    //_categoryListController = StreamController<ApiResponse<List<CategoryModel>>>();
    _categoryListController=BehaviorSubject<ApiResponse<List<CategoryModel>>>();
    _fetchCategory = FetchCategory();
    fetchCategoryList();
  }

  fetchCategoryList() async {
    categoryListSink.add(ApiResponse.loading('Fetching Category'));
    try {
      List<CategoryModel> categories = await _fetchCategory.fetch_category_list();
      categoryListSink.add(ApiResponse.completed(categories));
    } catch (e) {
      categoryListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _categoryListController?.close();
  }

}