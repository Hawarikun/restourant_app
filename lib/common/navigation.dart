import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/global_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(BuildContext context,String routeName, Object arguments) {
    final yourProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    yourProvider.setDetailRestaurantID((arguments as Restaurant).id);
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static back() => navigatorKey.currentState?.pop();
}
