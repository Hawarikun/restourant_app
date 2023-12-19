import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/common/navigation.dart';
import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      List<Restaurant> restaurant) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "dicoding news channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Recomended for you</b>";

    var titleNews = restaurant[0].name;

    List<Map<String, dynamic>> jsonList =
        restaurant.map((restaurant) => restaurant.toJson()).toList();

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(jsonList));
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        List<dynamic> jsonData = json.decode(payload);
        List<Restaurant> data =
            jsonData.map((item) => Restaurant.fromJson(item)).toList();
        var restaurant = data[0];

        // Accessing another provider
        var provider = Provider.of<GlobalProvider>(context, listen: false);
        provider.setDetailRestaurantID(restaurant.id);

        Navigation.intentWithData(context, route, restaurant);
      },
    );
  }
}
