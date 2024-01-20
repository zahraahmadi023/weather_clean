import 'package:flutter/material.dart';
import 'package:weather_clean/core/widgets/app_main_background.dart';
import 'package:weather_clean/core/widgets/bottom_nav.dart';
import 'package:weather_clean/feature/feature_bookmark/presentation/pagees/book_mark_screen.dart';
import 'package:weather_clean/feature/feature_weather/presentation/screens/home.dart';

// class MainWrapper extends StatelessWidget {
//   MainWrapper({Key? key}) : super(key: key);

//   final PageController pageController = PageController(initialPage: 0);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pageViewWidget = [
//       const HomeScreen(),
//       // BookMarkScreen(
//       //   pageController: pageController,
//       // ),
//     ];

//     var height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       extendBody: true,
//       bottomNavigationBar: BottomNav(Controller: pageController),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AppBackground.getBackGroundImage(), fit: BoxFit.cover),
//         ),
//         height: height,
//         child: PageView(
//           controller: pageController,
//           children: pageViewWidget,
//         ),
//       ),
//     );
//   }
// }

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> PageViewWidget = [
      const HomeScreen(),
      BookMarkScreen(
        pageController: pageController,
      ),
    ];
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AppBackground.getBackGroundImage(), fit: BoxFit.cover),
        ),
        height: height,
        child: PageView(
          controller: pageController,
          children: PageViewWidget,
        ),
      ),
      bottomNavigationBar: BottomNav(
        Controller: pageController,
      ),
    );
  }
}


// class MainWrapper extends StatefulWidget {
//   const MainWrapper({super.key});

//   @override
//   State<MainWrapper> createState() => _MainWrapperState();
// }

// class _MainWrapperState extends State<MainWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     //call event
//     BlocProvider.of<HomeBlocBloc>(context).add(LoadCwEvent("Zocca"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBlocBloc, HomeState>(
//       builder: (context, state) {
//         if (state.cwStatuse is CwLoading) {
//           return SafeArea(
//             child: Scaffold(
//               body: Container(
//                 child: Center(
//                   child: Text("loading"),
//                 ),
//               ),
//             ),
//           );
//         }
//         if (state.cwStatuse is CwLoading) {
//           return Container(
//             child: Center(
//               child: Text("loading"),
//             ),
//           );
//         }
//         if (state.cwStatuse is CwCompleted) {
//           //cast
//           CwCompleted cwCompleted = state.cwStatuse as CwCompleted;
//           final CurrentCityEntity currentCityEntity =
//               cwCompleted.currentCityEntity;
//           return Center(
//             child: Text(currentCityEntity.name.toString()),
//           );
//         }
//         if (state.cwStatuse is CwError) {
//           return Container(
//             child: Center(
//               child: Text("error"),
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }
// }
