import 'package:weather_clean/feature/feature_weather/domain/entities/current_city_entity.dart';

abstract class CwStatuse {}

class CwLoading extends CwStatuse {}

class CwCompleted extends CwStatuse {
  final CurrentCityEntity currentCityEntity;
  CwCompleted(this.currentCityEntity);
}

class CwError extends CwStatuse {
  final String error;
  CwError(this.error);
}
