import 'dart:async';

import 'package:floor/floor.dart';
import 'package:weather_clean/feature/feature_bookmark/data/data_soource/local/city_dao.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/entities/city_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  late CityDao cityDao;
}
