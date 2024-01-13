import 'package:weather_clean/core/useCase/usecase.dart';
import 'package:weather_clean/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_clean/feature/feature_weather/domain/repository/repository_weaather.dart';

class GetSuggestionCityUseCase implements UseCase<List<Data>, String> {
  final WeatherRepository _weatherRepository;
  GetSuggestionCityUseCase(this._weatherRepository);

  @override
  Future<List<Data>> call(String params) {
    return _weatherRepository.fetchSuggestData(params);
  }
}
