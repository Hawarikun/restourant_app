import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/common/navigation.dart';
import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/data/db/database_helper.dart';
import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/database_provider.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/provider/scheduling_provider.dart';
import 'package:restourant_app/package/utils/background_service.dart';
import 'package:restourant_app/package/utils/notification_helper.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/pages/main_page.dart';
import 'package:restourant_app/common/style.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Global Provider
        ChangeNotifierProvider(
          create: (context) => GlobalProvider(
            apiService: ApiService(),
            context: context,
          ),
        ),

        /// Database Provider
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),

        /// scheduling Provider
        ChangeNotifierProvider(
          create: (context) => SchedulingProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Dicoding - Restaurant_App',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
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
          nextScreen: const MainPage(),
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
