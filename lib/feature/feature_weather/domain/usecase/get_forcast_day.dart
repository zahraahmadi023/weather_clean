import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/core/useCase/usecase.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/domain/repository/repository_weaather.dart';

class GetForecastWeatherUseCase
    implements UseCase<DataState<ForecastDaysEntity>, ForecastParams> {
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }
}
