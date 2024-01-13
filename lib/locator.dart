import 'package:get_it/get_it.dart';
import 'package:weather_clean/feature/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_clean/feature/feature_weather/data/repository/weather_repository_impl.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_current_weather.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/home_bloc_bloc.dart';

import 'feature/feature_weather/domain/repository/repository_weaather.dart';

GetIt locator = GetIt.instance;
setup() {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  //repositori
  locator
      .registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));

  //usecase

  locator.registerSingleton<GetCurrentWeatherUseCas>(
      GetCurrentWeatherUseCas(locator()));

  locator.registerSingleton<GetForecastWeatherUseCase>(
      GetForecastWeatherUseCase(locator()));

  ///bloc
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(), locator()));
}
