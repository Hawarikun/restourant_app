import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/data/api/api_service.dart';

import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/pages/home_page.dart';
import 'package:restourant_app/style/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          GlobalProvider(apiService: ApiService(), context: context),
      child: MaterialApp(
        title: 'Dicoding - Restaurant_App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          textTheme: myTextTheme,
          useMaterial3: true,
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),

        /// Splash Screen
        home: AnimatedSplashScreen(
          splash: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryColor,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              size: 54,
              color: Colors.white,
            ),
          ),
          nextScreen: const HomePage(),
          splashTransition: SplashTransition.fadeTransition,
        ),
        routes: {
          RestaurantDetail.routeName: (context) => RestaurantDetail(
                restaurant:
                    ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
        },
      ),
    );
  }
}
