import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/source_chip.dart';

/// Widget test suite for [SourceChip] atom component.
void main() {
  /// Helper function to wrap [SourceChip] inside a [MaterialApp] for proper rendering context.
  Widget createWidgetUnderTest({required String label}) {
    return MaterialApp(
      home: Scaffold(body: SourceChip(label: label)),
    );
  }

  testWidgets('should render label string converted to UPPERCASE', (
    WidgetTester tester,
  ) async {
    // Arrange & Act: Build SourceChip with lowercase text 'bbc news'
    await tester.pumpWidget(createWidgetUnderTest(label: 'bbc news'));
    // Assert: Verify that text is transformed to UPPERCASE ('BBC NEWS') on UI
    final uppercaseTextFinder = find.text('BBC NEWS');
    expect(uppercaseTextFinder, findsOneWidget);
  });

  testWidgets('should find [SourceChip] widget in the widget tree', (
    WidgetTester tester,
  ) async {
    // Arrange & Act: Build SourceChip
    await tester.pumpWidget(createWidgetUnderTest(label: 'techcrunch'));
    // Assert: Verify widget instance exists
    expect(find.byType(SourceChip), findsOneWidget);
  });
}
