import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_primary_button.dart';

/// Widget test suite for [AppPrimaryButton].
///
///  Verifies rendering behavior for standard and icon-based primary buttons,
///  along with user tap interaction handling.

void main() {
  group('AppPrimaryButton Widget Tests', () {
    testWidgets('should render label text and trigger onPressed when tapped', (
      tester,
    ) async {
      // Arrange: Track button tap state
      bool wasPressed = false;

      // Act: Pump widget into test tree
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              text: 'Click Me',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Assert: Verify label text is rendered
      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Icon), findsNothing);

      // Act: Tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert: Verify callback was invoked
      expect(wasPressed, isTrue);
    });

    testWidgets('should render icon alongside label when icon is provided', (
      tester,
    ) async {
      // Act: Pump button configured with an icon
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              text: 'Explore News',
              icon: Icons.newspaper,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert: Verify both text and icon are visible in widget tree
      expect(find.text('Explore News'), findsOneWidget);
      expect(find.byIcon(Icons.newspaper), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
