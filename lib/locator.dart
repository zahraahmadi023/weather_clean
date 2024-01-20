import 'package:get_it/get_it.dart';
import 'package:weather_clean/feature/feature_bookmark/data/data_soource/local/database.dart';
import 'package:weather_clean/feature/feature_bookmark/data/repository/city_repositoryImpl.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/delete_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/get_all_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/get_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/save_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/presentation/bloc/bloc/bookmark_bloc.dart';
import 'package:weather_clean/feature/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather_clean/feature/feature_weather/data/repository/weather_repository_impl.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_current_weather.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/home_bloc_bloc.dart';

import 'feature/feature_weather/domain/repository/repository_weaather.dart';

GetIt locator = GetIt.instance;
setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  //repositori
  locator
      .registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
  locator
      .registerSingleton<CityRepository>(CityRepositoryImpl(database.cityDao));

  //usecase

  locator.registerSingleton<GetCurrentWeatherUseCas>(
      GetCurrentWeatherUseCas(locator()));

  locator.registerSingleton<GetForecastWeatherUseCase>(
      GetForecastWeatherUseCase(locator()));

  //bookmark
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));

  locator.registerSingleton<DeleteCityUseCase>(DeleteCityUseCase(locator()));

  locator.registerSingleton<GetCityUseCase>(GetCityUseCase(locator()));

  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));

  ///bloc
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(), locator()));
  locator.registerSingleton<BookmarkBloc>(
      BookmarkBloc(locator(), locator(), locator(), locator()));
}
