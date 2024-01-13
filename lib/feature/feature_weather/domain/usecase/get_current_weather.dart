import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/core/useCase/usecase.dart';
import 'package:weather_clean/feature/feature_weather/domain/repository/repository_weaather.dart';

import '../entities/current_city_entity.dart';

class GetCurrentWeatherUseCas extends UseCase{
  final WeatherRepository weatherRepository;
  GetCurrentWeatherUseCas(this.weatherRepository);

// Future<DataState<CurrentCityEntity>> execute(String cityName){
//     return weatherRepository.fetchCurrentWeatherData(cityName);
//   }
  
  @override
  Future call(cityName) {//cityName==param
    return weatherRepository.fetchCurrentWeatherData(cityName);
  }

}