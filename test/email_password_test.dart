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


  testWidgets('Authentication Testing', (WidgetTester tester) async {
    print('Begin: Authentication Testing');

    await tester.pumpWidget(createWidgetForTesting(child: const LogInView()));
    await tester.pumpAndSettle();

    // Email
    expect(find.text('Email'), findsOneWidget);
    final emailField = find.ancestor(
      of: find.text('Email'),
      matching: find.byType(TextField),
    );
    await tester.enterText(emailField, "email@domain.de");

    // Password
    expect(find.text('Password'), findsOneWidget);
    final passwordField = find.ancestor(
      of: find.text('Password'),
      matching: find.byType(TextField),
    );
    await tester.enterText(emailField, "strengGeheim");

    // Tap the login button.
    final loginButton = find.ancestor(
      of: find.text('LOGIN'),
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(loginButton);
    // wait
    //await tester.runAsync(() async {
    // await Future.delayed(Duration(seconds: 10));
    //});
    // test successful navigation to home
    //expect(find.byType(HomeView), findsOneWidget);

    print('End: Authentication Testing');
  });


// Define a test. The TestWidgets function also provides a WidgetTester
// to work with. The WidgetTester allows you to build and interact
// with widgets in the test environment.
  /*
  testWidgets('Test Login with email and password', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(createWidgetForTesting(child: const LogInView()));

    // Email
    var emailField = find.text('Email').last;
    //expect(find.text('Email'), findsOneWidget);
    await tester.enterText(emailField, 'email@domain.de');

    // pw
    //final passwordField = find.text('Password').last;
    //expect(find.text('Password'), findsOneWidget);
    //await tester.enterText(passwordField, '123');
    //expect(find.text('123'), findsNothing); // 3 characters shouldn't be allowed
    //expect(find.text('12'), findsOneWidget);

    //print('End: Test Login with email and password');
  });
  */
}
