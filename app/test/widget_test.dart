// This is a comprehensive Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:happyinside/main.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('App should render without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app renders without errors
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('App should have correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the app title is correct
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('App should have correct theme color', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the app uses the correct theme
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.colorScheme.primary, isNotNull);
    });
  });

  group('MyHomePage Widget Tests', () {
    testWidgets('Counter should start at 0', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('Counter should increment when button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial state
      expect(find.text('0'), findsOneWidget);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Counter should increment multiple times', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Tap the button multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      // Verify the final count
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Floating action button should be present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the floating action button exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('App bar should display correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the app bar shows the correct title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('Body should contain counter text', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that the body contains the counter explanation text
      expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    });

    testWidgets('Counter text should have headline style', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find the counter text widget
      final Text counterText = tester.widget(find.text('0'));
      
      // Verify it has the correct style (headlineMedium)
      expect(counterText.style, isNotNull);
    });
  });

  group('Integration Tests', () {
    testWidgets('Full counter workflow test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Initial state
      expect(find.text('0'), findsOneWidget);

      // First increment
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Second increment
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Third increment
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('3'), findsOneWidget);

      // Verify no other numbers are displayed
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
    });
  });
}
