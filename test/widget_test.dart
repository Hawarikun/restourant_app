import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('finds a Text widget', (tester) async {
    /// Build an App with a Text widget that displays the letter 'Explore Restaurant'.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text(
          "Explore Restaurant",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ));

    /// Find a widget that displays the letter 'H'.
    expect(find.text('Explore Restaurant'), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    /// Define the test key.
    const testKey = Key('K');

    /// Build a MaterialApp with the testKey.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    /// Find the MaterialApp widget using the testKey.
    expect(find.byKey(testKey), findsOneWidget);
  });
}
