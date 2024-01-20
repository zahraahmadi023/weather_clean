import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/core/useCase/usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/delete_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/get_all_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/get_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/domain/usecase/save_city_usecase.dart';
import 'package:weather_clean/feature/feature_bookmark/presentation/bloc/bloc/get_city_status.dart';
import 'package:weather_clean/feature/feature_bookmark/presentation/bloc/bloc/save_city_status.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/delete_city_status.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/get_all_city_status.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  GetCityUseCase getCityUseCase;
  SaveCityUseCase saveCityUseCase;
  DeleteCityUseCase deleteCityUseCase;
  GetAllCityUseCase getAllCityUseCase;
  BookmarkBloc(this.getCityUseCase, this.saveCityUseCase,
      this.deleteCityUseCase, this.getAllCityUseCase)
      : super(BookmarkState(
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial(),
            getAllCityStatus: GetAllCityLoading())) {
    on<GetCityByNameEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(
        newCityStatus: GetCityLoading(),
      ));

      DataState dataState = await getCityUseCase(event.cityName);

      /// emit Complete state
      if (dataState is DataSuccess) {
        emit(state.copyWith(newCityStatus: GetCityCompleted(dataState.data)));
      }

      ///emit  error state

      if (dataState is DataFailed) {
        emit(state.copyWith(
            newCityStatus: GetCityError(dataState.error.toString())));
      }
    });

    /// Save City Event
    on<SaveCwEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(newSaveStatus: SaveCityLoading()));

      DataState dataState = await saveCityUseCase(event.name);

      /// emit Complete state
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSaveStatus: SaveCityCompleted(dataState.data)));
      }

      /// emit Error state
      if (dataState is DataFailed) {
        emit(state.copyWith(newSaveStatus: SaveCityError(dataState.error)));
      }

      /// set to init again SaveCity (برای بار دوم و سوم و غیره باید وضعیت دوباره به حالت اول برگرده وگرنه بوکمارک پر خواهد ماند)
      on<SaveCityInitialEvent>((event, emit) async {
        emit(state.copyWith(newSaveStatus: SaveCityInitial()));
      });
    });

    //deleted
    on<DeleteCityEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(newdeleteCityStatus: DeleteCityLoading()));

      DataState dataState = await deleteCityUseCase(event.name);

      /// emit Complete state
      if (dataState is DataSuccess) {
        emit(state.copyWith(
            newdeleteCityStatus: DeleteCityCompleted(dataState.data)));
      }

      /// emit Error state
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newdeleteCityStatus: DeleteCityError(dataState.error)));
      }

      ///get all city
      on<GetAllCityEvent>((event, emit) async {
        /// emit Loading state
        emit(state.copyWith(newgetAllCityStatus: GetAllCityLoading()));

        DataState dataState = await getAllCityUseCase(NoParams());

        /// emit Complete state
        if (dataState is DataSuccess) {
          emit(state.copyWith(
              newgetAllCityStatus: GetAllCityCompleted(dataState.data)));
        }

        /// emit Error state
        if (dataState is DataFailed) {
          emit(state.copyWith(
              newgetAllCityStatus: GetAllCityError(dataState.error)));
        }
      });
    });
  }
}
