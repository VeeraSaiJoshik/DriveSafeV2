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
    apiKey: 'AIzaSyBlosrlYiDyNqDPisqoDMkPTkl-iE9DBI0',
    appId: '1:373292854298:web:71ff074bbdc224b92d35a3',
    messagingSenderId: '373292854298',
    projectId: 'drivesafe-ccb3e',
    authDomain: 'drivesafe-ccb3e.firebaseapp.com',
    storageBucket: 'drivesafe-ccb3e.appspot.com',
    measurementId: 'G-JZV3TGXWH8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCweWp_n2DrwM1-syfbcvEKVj3-Il0Wrfs',
    appId: '1:373292854298:android:c3dfcb06a876766a2d35a3',
    messagingSenderId: '373292854298',
    projectId: 'drivesafe-ccb3e',
    storageBucket: 'drivesafe-ccb3e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaiXugdPT38wtKRDga0EsVM9Wz5XQJvwM',
    appId: '1:373292854298:ios:ca7541c8cff634102d35a3',
    messagingSenderId: '373292854298',
    projectId: 'drivesafe-ccb3e',
    storageBucket: 'drivesafe-ccb3e.appspot.com',
    iosClientId: '373292854298-j3dsqvotnjvtaum9luls7i32kf38alqj.apps.googleusercontent.com',
    iosBundleId: 'com.testing.drivesafev2',
  );
}
