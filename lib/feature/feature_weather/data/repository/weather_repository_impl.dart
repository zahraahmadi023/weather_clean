import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/feature/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_clean/feature/feature_weather/data/models/current_model.dart';
import 'package:weather_clean/feature/feature_weather/data/models/forcast_day_model.dart';
import 'package:weather_clean/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/suggest_city_entity.dart';
import 'package:weather_clean/feature/feature_weather/domain/repository/repository_weaather.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName) async {
    try {
      //call Appi
      Response response = await apiProvider.callCurrentWeather(cityName);
      if (response.statusCode == 200) {
        CurrentCityEntity currentCityEntity =
            CurrentCityModel.fromJson(response.data);

        return DataSuccess(currentCityEntity);
      } else {
        return const DataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
      ForecastParams params) async {
    try {
      Response response = await apiProvider.sendRequest7DaysForcast(params);

      if (response.statusCode == 200) {
        ForecastDaysEntity forecastDaysEntity =
            ForecastDaysModel.fromJson(response.data);
        print(response.data);
        log('data: ${response.data}');
        print("response.data......................");
        return DataSuccess(forecastDaysEntity);
      } else {
        return const DataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {
    Response response = await apiProvider.sendRequestCitySuggestion(cityName);

    SuggestCityEntity suggestCityEntity =
        SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;
  }
}
