
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/core/useCase/usecase.dart';

import '../repository/city_repository.dart';

class DeleteCityUseCase implements UseCase<DataState<String>, String>{
  final CityRepository _cityRepository;
  DeleteCityUseCase(this._cityRepository);

  @override
  Future<DataState<String>> call(String params) {
    return _cityRepository.deletCityByName(params);
  }
}