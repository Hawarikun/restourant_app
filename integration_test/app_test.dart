import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Test SingleChildScrollView widget',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              key: Key("Scrollable"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Recommendation for you",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ],
              ),
            ),
          ),
        ),
      );

      /// Verify that the text "Recommendation for you" is displayed
      expect(find.text("Recommendation for you"), findsOneWidget);

      /// Verify that the SingleChildScrollView scrolls
      await tester.drag(
          find.byKey(const Key("Scrollable")), const Offset(0.0, -200.0));
      await tester.pump();

      /// Verify that the scrolled content is still visible
      expect(find.text("Recommendation for you"), findsOneWidget);
    });
  });
}
