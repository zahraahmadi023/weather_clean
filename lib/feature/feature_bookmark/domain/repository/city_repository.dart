import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/entities/city_entity.dart';

 abstract class CityRepository {
  Future<DataState<City>> saveCityToDB(String CityName);

  Future<DataState<List<City>>> getAllCityFromDB();

  Future<DataState<City?>> findCityByNameBody(String name);

Future<DataState<String>> deletCityByName(String name);



  
}