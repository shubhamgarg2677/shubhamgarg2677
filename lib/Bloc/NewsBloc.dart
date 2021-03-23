import 'dart:async';

import 'package:news_website/ApiFetch/FetchNews.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/NewsDataModel.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  FetchNews _fetchNews;

  StreamController _newslistcontroller;

  StreamSink<ApiResponse<Map<int,Map<int,Map<int,NewsDataModel>>>>> get newsListSink =>
      _newslistcontroller.sink;

  Stream<ApiResponse<Map<int,Map<int,Map<int,NewsDataModel>>>>> get newsListStream =>
      _newslistcontroller.stream;

  NewsBloc(int country,int category,int limit,int offset)
  {
    _fetchNews = new FetchNews();
    _newslistcontroller = BehaviorSubject<ApiResponse<Map<int,Map<int,Map<int,NewsDataModel>>>>>();
    fetchCountryList(country, category, limit, offset);
  }

  fetchCountryList(int country,int category,int limit,int offset) async {
    newsListSink.add(ApiResponse.loading('Fetching News'));
    try {
      Map<int,Map<int,Map<int,NewsDataModel>>> new_content = await _fetchNews.fetch_news_list(country, category, limit, offset);
      newsListSink.add(ApiResponse.completed(new_content));
    } catch (e) {
      newsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _newslistcontroller?.close();
  }

}