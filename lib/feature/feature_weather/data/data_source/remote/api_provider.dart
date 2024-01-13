import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();
  var apiKey = Constants.apiKey;

  /// current weather api call
  Future<dynamic> callCurrentWeather(cityName) async {
    var response = await _dio.get('${Constants.basUrl}/data/2.5/weather',
        queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'});
    // print(response.statusCode);
    // print("response.statusCode111");
    // print(response.data);
    return response;
  }

  /// 7 days forecast api
  Future<dynamic> sendRequest7DaysForcast(ForecastParams params) async {
    var response = await _dio
        .get("${Constants.basUrl}/data/2.5/onecall", queryParameters: {
      'lat': params.lat,
      'lon': params.lon,
      'exclude': 'minutely,hourly',
      'appid': apiKey,
      'units': 'metric'
    });
    print(response.statusCode);
    print("response.statusCode22222");
    log('data: ${response.data}');
    //print("...........................................");

    return response;
  }

  /// city name suggest api
  Future<dynamic> sendRequestCitySuggestion(String prefix) async {
    var response = await _dio.get(
        "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

    return response;
  }
}




// class ApiProvider {
//   Dio _dio = Dio();
//   var apiKey = Constants.apiKey;
//   //current api call
//   Future<dynamic> callCurrentWeather(cityName) async {
//     var response = await _dio.get(Constants.basUrl,
//         queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'});
//     print(response.data);

//     print("..........................");
//     print(response.statusCode);
//     return response;
//   }
// }
