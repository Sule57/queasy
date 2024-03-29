// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ',
    appId: '1:17686953226:web:81a053f17c2b317edd0ef3',
    messagingSenderId: '17686953226',
    projectId: 'quizzapp-eb0f2',
    authDomain: 'quizzapp-eb0f2.firebaseapp.com',
    databaseURL:
        'https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'gs://quizzapp-eb0f2.appspot.com',
    measurementId: 'G-MSF5DXS9QN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1M56SvsGngmwSllnRuSJZncnLGq1s0gE',
    appId: '1:17686953226:android:f3224179ba0b743ddd0ef3',
    messagingSenderId: '17686953226',
    projectId: 'quizzapp-eb0f2',
    databaseURL:
        'https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'gs://quizzapp-eb0f2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfTNR04cLFwme7KxEVVa5lQERdqvf6juI',
    appId: '1:17686953226:ios:f7e36aea36f9173ddd0ef3',
    messagingSenderId: '17686953226',
    projectId: 'quizzapp-eb0f2',
    databaseURL:
        'https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'gs://quizzapp-eb0f2.appspot.com',
    iosClientId:
        '17686953226-0dictdama32iud20bvdkq6t57n35t83a.apps.googleusercontent.com',
    iosBundleId: 'de.queasy.queasy',
  );
}
