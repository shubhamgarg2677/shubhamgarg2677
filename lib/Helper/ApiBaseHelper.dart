import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiBaseHelper {

  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    //var responseJson;
    http.Response response;
    try {
       response = await http.get(Uri.parse(url));
      //responseJson = jsonDecode(response.body);
      //responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      //throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return response;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        //throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        //throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        // throw FetchDataException(
        //     'Error occured while Communication with Server with StatusCode : ${response
        //         .statusCode}');
    }
  }

}