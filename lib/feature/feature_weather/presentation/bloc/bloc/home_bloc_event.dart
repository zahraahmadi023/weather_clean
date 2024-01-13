part of 'home_bloc_bloc.dart';

@immutable
abstract class HomeBlocEvent {}

class LoadCwEvent extends HomeBlocEvent {
  final String cityName;
  LoadCwEvent(this.cityName);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


class LoadFwEvent extends HomeBlocEvent {
  final ForecastParams forecastParams;
  LoadFwEvent(this.forecastParams);
}

