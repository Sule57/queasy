import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:queasy/main.dart';
import 'package:queasy/view/home_view.dart';
import 'package:queasy/view/login_view.dart';

import '../test/firebase_mock.dart';

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  //setupFirebaseAuthMocks();



  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
    "Login fails",
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Email
      expect(find.text('Email'), findsOneWidget);
      final emailField = find.ancestor(
        of: find.text('Email'),
        matching: find.byType(TextField),
      );
      await tester.tap(emailField);
      await tester.enterText(emailField, "unknown@queasy.de");
      //await Future.delayed(const Duration(seconds: 2), (){});

      // Password
      expect(find.text('Password'), findsOneWidget);
      final passwordField = find.ancestor(
        of: find.text('Password'),
        matching: find.byType(TextField),
      );
      await tester.tap(passwordField);
      await tester.enterText(emailField, "hackertest");
      //await Future.delayed(const Duration(seconds: 2), (){});

      // Tap the login button.
      final loginButton = find.ancestor(
        of: find.text('LOGIN'),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(loginButton);
      await tester.runAsync(() async {
        await Future.delayed(Duration(seconds: 5));
      });
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await Future.delayed(Duration(seconds: 5));
      });

      // stays in Login view!
      expect(find.byType(HomeView), findsNothing);
      expect(find.byType(LogInView), findsOneWidget);

      await tester.runAsync(() async {
        await Future.delayed(Duration(seconds: 5));
      });

      print('End: Login');
    },
  );

  testWidgets(
      "Login successfull",
      (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());

        // Email
        expect(find.text('Email'), findsOneWidget);
        final emailField = find.ancestor(
          of: find.text('Email'),
          matching: find.byType(TextField),
        );
        await tester.tap(emailField);
        await tester.enterText(emailField, "tester@queasy.de");
        //await Future.delayed(const Duration(seconds: 2), (){});

        // Password
        expect(find.text('Password'), findsOneWidget);
        final passwordField = find.ancestor(
          of: find.text('Password'),
          matching: find.byType(TextField),
        );
        await tester.tap(passwordField);
        await tester.enterText(emailField, "testpassword123");
        //await Future.delayed(const Duration(seconds: 2), (){});

        // Tap the login button.
        final loginButton = find.ancestor(
          of: find.text('LOGIN'),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(loginButton);
        await tester.runAsync(() async {
          await Future.delayed(Duration(seconds: 5));
        });
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          await Future.delayed(Duration(seconds: 5));
        });

        // test successful navigation to home
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.byType(LogInView), findsNothing);

        await tester.runAsync(() async {
          await Future.delayed(Duration(seconds: 5));
        });

        print('End: Login');
      },
  );
}