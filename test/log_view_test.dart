import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/view/home_view.dart';
import 'package:queasy/view/login_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:queasy/main.dart';
import 'firebase_mock.dart';



void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }


  testWidgets('Test login view widgets', (WidgetTester tester) async {
    print('Begin: Test login view widgets');

    await tester.pumpWidget(createWidgetForTesting(child: const LogInView()));
    await tester.pumpAndSettle();

    // Email
    expect(find.text('Email'), findsOneWidget);
    final emailField = find.ancestor(
      of: find.text('Email'),
      matching: find.byType(TextField),
    );
    await tester.tap(emailField);
    await tester.enterText(emailField, "email@domain.de");

    // Password
    expect(find.text('Password'), findsOneWidget);
    final passwordField = find.ancestor(
      of: find.text('Password'),
      matching: find.byType(TextField),
    );
    await tester.tap(passwordField);
    await tester.enterText(emailField, "strengGeheim");

    // Tap the login button.
    final loginButton = find.ancestor(
      of: find.text('LOGIN'),
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(loginButton);
    await tester.pump();


    print('End: Test login view widgets');
  });


}
