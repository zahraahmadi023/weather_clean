part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable {
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  final DeleteCityStatus deleteCityStatus;
  final GetAllCityStatus getAllCityStatus;
  BookmarkState({
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.deleteCityStatus,
    required this.getAllCityStatus,
  });

  BookmarkState copyWith({
    GetCityStatus? newCityStatus,
    SaveCityStatus? newSaveStatus,
    DeleteCityStatus? newdeleteCityStatus,
    GetAllCityStatus? newgetAllCityStatus,
  }) {
    return BookmarkState(
        getCityStatus: newCityStatus ?? getCityStatus,
        saveCityStatus: newSaveStatus ?? saveCityStatus,
        deleteCityStatus: newdeleteCityStatus ?? deleteCityStatus,
        getAllCityStatus: newgetAllCityStatus ?? getAllCityStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [getCityStatus, saveCityStatus];
}
