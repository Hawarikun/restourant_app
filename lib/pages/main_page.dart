import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/utils/notification_helper.dart';

import 'package:restourant_app/pages/bookmark_page.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/pages/home_page.dart';
import 'package:restourant_app/common/style.dart';
import 'package:restourant_app/pages/setting_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  static final List<Widget> _pageOptions = <Widget>[
    const HomePage(),
    const BookmarkPage(),
    const SettingPage()
  ];

  @override
  void initState() {
    _notificationHelper.configureSelectNotificationSubject(
        context, RestaurantDetail.routeName);
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, provider, _) => Scaffold(
        body: _pageOptions.elementAt(provider.currentIndex),
        bottomNavigationBar: Card(
          surfaceTintColor: Colors.white,
          elevation: 4,
          child: SalomonBottomBar(
            currentIndex: provider.currentIndex,
            onTap: (i) => provider.setCurrentIndex(i),
            items: [
              /// home
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text("Home"),
                selectedColor: primaryColor,
              ),

              /// bookmark
              SalomonBottomBarItem(
                icon: const Icon(Icons.bookmark_border_outlined),
                title: const Text("Bookmark"),
                selectedColor: primaryColor,
                activeIcon: const Icon(Icons.bookmark),
              ),

              /// setting
              SalomonBottomBarItem(
                icon: const Icon(Icons.settings),
                title: const Text("Setting"),
                selectedColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
