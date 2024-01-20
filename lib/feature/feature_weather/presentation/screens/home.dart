import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_clean/core/params/params.dart';
import 'package:weather_clean/core/utils/date_convert.dart';
import 'package:weather_clean/core/widgets/app_main_background.dart';
import 'package:weather_clean/core/widgets/dot_loading_widget.dart';
import 'package:weather_clean/feature/feature_bookmark/presentation/bloc/bloc/bookmark_bloc.dart';
import 'package:weather_clean/feature/feature_weather/data/models/forcast_day_model.dart';
import 'package:weather_clean/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather_clean/feature/feature_weather/domain/entities/forcast_day.dart';
import 'package:weather_clean/feature/feature_weather/domain/usecase/get_suggestion_city.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/cw_state.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/fw_state.dart';
import 'package:weather_clean/feature/feature_weather/presentation/bloc/bloc/home_bloc_bloc.dart';
import 'package:weather_clean/feature/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:weather_clean/feature/feature_weather/presentation/widgets/day_weather_veiw.dart';
import 'package:weather_clean/locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent("Tehran"));
    //BlocProvider.of<HomeBloc>(context).add(LoadFwEvent());
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 97, 118, 135),
        body: SafeArea(
            child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      onSubmitted: (String perfix) {
                        textEditingController.text = perfix;
                        BlocProvider.of<HomeBloc>(context)
                            .add(LoadCwEvent(perfix));
                      },
                      controller: textEditingController,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          hintText: "enter city ",
                          hintStyle: TextStyle(color: Colors.white),
                          // focusColor:OutlineInputBorder(borderSide:BorderSide(color: Colors.white) ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    suggestionsCallback: (String perfixe) {
                      return getSuggestionCityUseCase(perfixe);
                    },
                    itemBuilder: (context, Data model) {
                      return ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(model.name!),
                        subtitle: Text('${model.region}, ${model.country!}'),
                      );
                    },
                    onSuggestionSelected: (Data model) {
                      textEditingController.text = model.name!;
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent(model.name!));
                    },
                  ),
                ),

                ///////
                const SizedBox(
                  width: 10,
                ),

                BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) {
                  if (previous.cwStatuse == current.cwStatuse) {
                    return false;
                  }
                  return true;
                }, builder: (context, state) {
                  /// show Loading State for Cw
                  if (state.cwStatuse is CwLoading) {
                    return const CircularProgressIndicator();
                  }

                  /// show Error State for Cw
                  if (state.cwStatuse is CwError) {
                    return IconButton(
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text("please load a city!"),
                        //   behavior: SnackBarBehavior.floating, // Add this line
                        // ));
                      },
                      icon: const Icon(Icons.error,
                          color: Colors.white, size: 35),
                    );
                  }
                  if (state.cwStatuse is CwCompleted) {
                    final CwCompleted cwComplete =
                        state.cwStatuse as CwCompleted;
                    BlocProvider.of<BookmarkBloc>(context).add(
                        GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                    return BookMarkIcon(
                        name: cwComplete.currentCityEntity.name!);
                  }

                  return Container();
                })
              ],
            ),

            //main ui
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) {
                if (previous.cwStatuse == current.cwStatuse) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state.cwStatuse is CwLoading) {
                  return Expanded(child: DotLoadingWidget());
                }

                if (state.cwStatuse is CwCompleted) {
                  //cast
                  CwCompleted cwCompleted = state.cwStatuse as CwCompleted;
                  final CurrentCityEntity currentCityEntity =
                      cwCompleted.currentCityEntity;

                  /// create params for api call
                  final ForecastParams forecastParams = ForecastParams(
                      currentCityEntity.coord!.lat!,
                      currentCityEntity.coord!.lon!);

                  /// start load Fw event
                  BlocProvider.of<HomeBloc>(context)
                      .add(LoadFwEvent(forecastParams));

                  /// change Times to Hour --5:55 AM/PM----
                  final sunrise = DateConverter.changeDtToDateTimeHour(
                      currentCityEntity.sys!.sunrise,
                      currentCityEntity.timezone);
                  final sunset = DateConverter.changeDtToDateTimeHour(
                      currentCityEntity.sys!.sunset,
                      currentCityEntity.timezone);

                  return Expanded(
                      child: ListView(children: [
                    Padding(padding: EdgeInsets.only(top: height * 0.02)),
                    SizedBox(
                      height: 400,
                      width: width,
                      child: PageView.builder(
                        itemCount: 2,
                        allowImplicitScrolling: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: pageController,
                        itemBuilder: (context, position) {
                          if (position == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                ),
                                Text(
                                  currentCityEntity.name!,
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                Text(
                                  currentCityEntity.weather![0].description!,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                AppBackground.setIconForMain(
                                    currentCityEntity.weather![0].description!),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${currentCityEntity.main!.temp!.round()}\u00B0",
                                  style: const TextStyle(
                                      fontSize: 50, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          "max",
                                          style: TextStyle(
                                              fontSize: 30, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${currentCityEntity.main!.tempMax!.round()}\u00B0',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    //divider
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        width: 2,
                                        height: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          "min",
                                          style: TextStyle(
                                              fontSize: 30, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${currentCityEntity.main!.tempMin!.round()}\u00B0',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return Container(
                              // height: 500,
                              // width: width,
                              color: Colors.amber,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /// pageView Indicator
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        // PageController
                        count: 2,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 5,
                          activeDotColor: Colors.white,
                        ),
                        // your preferred effect
                        onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.bounceOut,
                        ),
                      ),
                    ),

                    /// divider
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),

                    /// forecast weather 7 days
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (BuildContext context, state) {
                                /// show Loading State for Fw
                                if (state.fwStatus is FwLoading) {
                                  return const DotLoadingWidget();
                                }

                                /// show Completed State for Fw
                                if (state.fwStatus is FwCompleted) {
                                  /// casting
                                  final FwCompleted fwCompleted =
                                      state.fwStatus as FwCompleted;
                                  final ForecastDaysEntity forecastDaysEntity =
                                      fwCompleted.forecastDaysEntity;
                                  final List<Daily> mainDaily =
                                      forecastDaysEntity.daily!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return DaysWeatherView(
                                        daily: mainDaily[index],
                                      );
                                    },
                                  );
                                }

                                /// show Error State for Fw
                                if (state.fwStatus is FwError) {
                                  final FwError fwError =
                                      state.fwStatus as FwError;
                                  return Center(
                                    child: Text(fwError.message!),
                                  );
                                }

                                /// show Default State for Fw
                                return Container();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// divider
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    /// divider
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    /// last Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "wind speed",
                              style: TextStyle(
                                fontSize: height * 0.017,
                                color: Colors.amber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${currentCityEntity.wind!.speed!} m/s",
                                style: TextStyle(
                                  fontSize: height * 0.016,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "sunrise",
                                style: TextStyle(
                                  fontSize: height * 0.017,
                                  color: Colors.amber,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  sunrise,
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "sunset",
                                style: TextStyle(
                                  fontSize: height * 0.017,
                                  color: Colors.amber,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  sunset,
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            color: Colors.white24,
                            height: 30,
                            width: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "humidity",
                                style: TextStyle(
                                  fontSize: height * 0.017,
                                  color: Colors.amber,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "${currentCityEntity.main!.humidity!}%",
                                  style: TextStyle(
                                    fontSize: height * 0.016,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]));

                  // return Center(
                  //   child: Text(currentCityEntity.name.toString()),
                  // );
                }
                if (state.cwStatuse is CwError) {
                  return const Center(
                    child: Text("error"),
                  );
                }
                return Container();
              },
            )
          ],
        )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
