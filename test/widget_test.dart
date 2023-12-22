import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/main.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/provider/scheduling_provider.dart';
import 'package:restourant_app/pages/home_page.dart';
import 'package:restourant_app/pages/setting_page.dart';

class StateMaker extends StatefulWidget {
  final Widget? child;
  const StateMaker({super.key, this.child});

  @override
  State<StateMaker> createState() => StateMakerState();
}

class StateMakerState extends State<StateMaker> {
  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return widget.child!;
    }
    return Container();
  }
}

void main() {
  group("Test widget", () {
    testWidgets('Test animated Splash Screen widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      var fab = find.byType(AnimatedSplashScreen);

      expect(fab, findsOneWidget);
    });

    testWidgets("Test HomePage widget", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: (context) =>
                GlobalProvider(apiService: ApiService(http.Client()), context: context),
            child: const HomePage()),
      ));

      var fabAppaBar = find.byKey(const ValueKey('searchBar'));
      var fabText = find.text("Restaurant");

      expect(fabAppaBar, findsOneWidget);
      expect(fabText, findsOneWidget);
    });

    testWidgets("Test SettingPage widget", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: (context) =>
              SchedulingProvider(),
            child: const SettingPage()),
      ));

      var fabAppaBar = find.byKey(const ValueKey('switch'));
      var fabSwitch = find.byType(Switch);

      expect(fabAppaBar, findsOneWidget);
      expect(fabSwitch, findsOneWidget);

    });
  });
}
