import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/resuorce/data_state.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_current_weather.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/cw_state.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/fw_state.dart';

part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBloc extends Bloc<HomeBlocEvent, HomeState> {
  final GetCurrentWeatherUseCas getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase getForecastWeatherUseCase;

  HomeBloc(
    this.getCurrentWeatherUseCase,
    this.getForecastWeatherUseCase,
  ) : super(HomeState(cwStatuse: CwLoading(), fwStatus: FwLoading())) {
    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newWStatuse: CwLoading()));

      DataState dataState = await getCurrentWeatherUseCase(event.cityName);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newWStatuse: CwCompleted(dataState.data)));
      }

      if (dataState is DataFailed) {
        emit(state.copyWith(newWStatuse: CwError(dataState.error!)));
      }
    });

    /// load 7 days Forecast weather for city Event
    on<LoadFwEvent>((event, emit) async {
      /// emit State to Loading for just Fw
      emit(state.copyWith(newFStatuse: FwLoading()));

      DataState dataState =
          await getForecastWeatherUseCase(event.forecastParams);

      /// emit State to Completed for just Fw
      if (dataState is DataSuccess) {
        emit(state.copyWith(newFStatuse: FwCompleted(dataState.data)));
      }

      /// emit State to Error for just Fw
      if (dataState is DataFailed) {
        emit(state.copyWith(newFStatuse: FwError(dataState.error)));
      }
    });
  }
}

// class HomeBloc extends Bloc<HomeBlocEvent, HomeState> {
//   final GetCurrentWeatherUseCas getCurrentWeatherUseCas;
//   final GetForecastWeatherUseCase _getForecastWeatherUseCase;
//   HomeBloc(this.getCurrentWeatherUseCas,
//   this._getForecastWeatherUseCase)
//       : super(HomeState(
//           cwStatuse: CwLoading(),
//           fwStatus: FwLoading()
//         )) {
//     on<LoadCwEvent>((event, emit) async {
//       emit(state.copyWith(newWStatuse: CwLoading()));

//       DataState dataState = await getCurrentWeatherUseCas(event.cityName);

//       if (dataState is DataSuccess) {
//         emit(state.copyWith(newWStatuse: CwCompleted(dataState.data)));
//       }
//       if (dataState is DataFailed) {
//         emit(state.copyWith(newWStatuse: CwError(dataState.error!)));
//       }
//     });

//      on<LoadFwEvent>((event, emit) async {
//       /// emit State to Loading for just Fw
//       emit(state.copyWith(newFwStatus: FwLoading()));

//       DataState dataState =
//           await _getForecastWeatherUseCase(event.forecastParams);

//       /// emit State to Completed for just Fw
//       if (dataState is DataSuccess) {
//         emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
//       }

//       /// emit State to Error for just Fw
//       if (dataState is DataFailed) {
//         emit(state.copyWith(newFwStatus: FwError(dataState.error)));
//       }
//     });
  

//   }
// }
