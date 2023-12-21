import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/pages/home_page.dart';

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('SplashSreen with integration test',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) =>
              GlobalProvider(apiService: ApiService(), context: context),
          child: const HomePage(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text("Recommendation for you"), findsOneWidget);

      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0.0, -200));

      expect(find.text("Explore Restaurant"), findsOneWidget);

      await tester.pumpAndSettle();

      final Finder icon = find.byIcon(Icons.search);

      await tester.tap(icon);

      await tester.pumpAndSettle();

      final search = find.byKey(const ValueKey("searchBar"));

      await tester.enterText(search, "melting");

      await tester.pumpAndSettle();
    });
  });
}
