import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';

/// Organism widget test for [CustomAppBar].
void main() {
  /// Helper funvtion to build CustomAppBar inside MaterialApp
  Widget createWidgetUnderTest({
    required String title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: title, leading: leading, actions: actions),
      ),
    );
  }

  group('CustomAppBar Organism widget Test', () {
    testWidgets(
      'should render title string, leading back button, and action buttons, and trigger callbacks on tap',
      (WidgetTester tester) async {
        var isBackTapped = false;
        var isActionTapped = false;

        // Arrange & Act: Render CustomAppBar using IconButton
        await tester.pumpWidget(
          createWidgetUnderTest(
            title: AppStrings.appTitle,
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => isBackTapped = true,
            ),
            actions: [
              IconButton(
                onPressed: () => isActionTapped = true,
                icon: Icon(Icons.bookmark),
              ),
            ],
          ),
        );
        await tester.pump();

        // Assert: verify that the title string, leading back button, and actions are rendered in widget tree
        expect(find.text(AppStrings.appTitle), findsOneWidget);
        expect(find.byType(IconButton), findsNWidgets(2));
        expect(find.byIcon(Icons.chevron_left), findsOneWidget);
        expect(find.byIcon(Icons.bookmark), findsOneWidget);

        // Act: simulate a tap on leading button and action button
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.tap(find.byIcon(Icons.bookmark));

        // Assert: verify that tap handlers were invoked
        expect(isBackTapped, isTrue);
        expect(isActionTapped, isTrue);
      },
    );
  });
}
