import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_clean/core/widgets/main_wrapper.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/home_bloc_bloc.dart';
import 'package:weather_clean/locator.dart';

void main() async {
  //init locator
  await setup();

  runApp(MaterialApp(
    home: MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => locator<HomeBloc>(),
      ),
    ], child: MainWrapper()),
  ));
}
