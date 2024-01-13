import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class City extends Equatable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;

  City(this.name);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
