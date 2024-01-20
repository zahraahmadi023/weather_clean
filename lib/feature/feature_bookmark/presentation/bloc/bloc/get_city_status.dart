import 'package:equatable/equatable.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/entities/city_entity.dart';

class GetCityStatus extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCityLoading extends GetCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCityCompleted extends GetCityStatus {
  final City? city;
  GetCityCompleted(this.city);
  @override
  // TODO: implement props
  List<Object?> get props => [city];
}

class GetCityError extends GetCityStatus {
  final String massege;
  GetCityError(this.massege);
  @override
  // TODO: implement props
  List<Object?> get props => [massege];
}
