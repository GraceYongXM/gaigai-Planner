import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:gaigai_planner/main.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login Testing', (WidgetTester tester) async {
    await tester.pumpWidget(GaigaiPlanner());
    // renders the UI of the provided widget
    await tester.pumpAndSettle();
    // repeatedly calls pump for a given duration until there are no frames to
    // settle, which is usually required when you have some animations
    // pumpAndSettle is called after pumpWidget() because you want to wait for
    // the navigation animations to complete

    tester.printToConsole('Login page opens');

    expect(find.text('Log in'), findsOneWidget);

    await tester.enterText(
        find.byKey(const ValueKey('usernameLoginField')), 'tertle');
    await tester.enterText(
        find.byKey(const ValueKey('passwordLoginField')), 'tertle');
    await tester.tap(find.byKey(const ValueKey('LoginButton')));

    await addDelay(3000);
    // adds a delay of 3 seconds

    await tester.pumpAndSettle();
    // waits for all the animations to complete

    tester.printToConsole('Home page opens');
    expect(find.text('Gaigai Planner'), findsOneWidget);
  });
}
