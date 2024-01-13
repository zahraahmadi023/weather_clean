import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/forcast_day.dart';

abstract class WeatherRepository {
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
      ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);
}
