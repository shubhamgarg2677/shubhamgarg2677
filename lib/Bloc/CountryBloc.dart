import 'dart:async';
import 'package:news_website/ApiFetch/FetchCountry.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/CountryModel.dart';
import 'package:rxdart/rxdart.dart';


class CountryBloc{

  FetchCountry _fetchCountry;

  StreamController _countrylistcontroller;

  StreamSink<ApiResponse<List<CountryModel>>> get countryListSink =>
      _countrylistcontroller.sink;

  Stream<ApiResponse<List<CountryModel>>> get countryListStream =>
      _countrylistcontroller.stream;

  CountryBloc()
  {
    _countrylistcontroller=BehaviorSubject<ApiResponse<List<CountryModel>>>();
    _fetchCountry=FetchCountry();
    fetchCountryList();
  }

  fetchCountryList() async {
    countryListSink.add(ApiResponse.loading('Fetching Country'));
    try {
      List<CountryModel> countries = await _fetchCountry.fetch_country_list();
      countryListSink.add(ApiResponse.completed(countries));
    } catch (e) {
      countryListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _countrylistcontroller?.close();
  }

}