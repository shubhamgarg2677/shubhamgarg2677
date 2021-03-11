import 'dart:async';

import 'package:news_website/ApiFetch/FetchNews.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/NewsDataModel.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  FetchNews _fetchNews;

  StreamController _newslistcontroller;

  StreamSink<ApiResponse<List<NewsDataModel>>> get newsListSink =>
      _newslistcontroller.sink;

  Stream<ApiResponse<List<NewsDataModel>>> get newsListStream =>
      _newslistcontroller.stream;

  NewsBloc(int country,int category,int limit,int offset)
  {
    _fetchNews = new FetchNews();
    _newslistcontroller = BehaviorSubject<ApiResponse<List<NewsDataModel>>>();
    fetchCountryList(country, category, limit, offset);
  }

  fetchCountryList(int country,int category,int limit,int offset) async {
    newsListSink.add(ApiResponse.loading('Fetching News'));
    try {
      List<NewsDataModel> countries = await _fetchNews.fetch_news_list(country, category, limit, offset);
      newsListSink.add(ApiResponse.completed(countries));
    } catch (e) {
      newsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _newslistcontroller?.close();
  }

}