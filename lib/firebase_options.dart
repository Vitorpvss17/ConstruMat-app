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
        return macos;
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
    apiKey: 'AIzaSyD_4ylG5Rh4hrXAnGcb6c6s0H4-NhGyl3s',
    appId: '1:712084066958:web:36a54dc368c9ec67c16fdf',
    messagingSenderId: '712084066958',
    projectId: 'construmatapp-cma',
    authDomain: 'construmatapp-cma.firebaseapp.com',
    storageBucket: 'construmatapp-cma.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0R1509yOeq9RpddQfiYEJcKhpjINYd_I',
    appId: '1:712084066958:android:dce05f868ac65332c16fdf',
    messagingSenderId: '712084066958',
    projectId: 'construmatapp-cma',
    storageBucket: 'construmatapp-cma.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZI_BPI1l3d9JlCKXUP8uacdg5RKAhMgc',
    appId: '1:712084066958:ios:3422d2f65ec9432ac16fdf',
    messagingSenderId: '712084066958',
    projectId: 'construmatapp-cma',
    storageBucket: 'construmatapp-cma.appspot.com',
    iosBundleId: 'com.example.construmatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZI_BPI1l3d9JlCKXUP8uacdg5RKAhMgc',
    appId: '1:712084066958:ios:a7ed4273992fbabec16fdf',
    messagingSenderId: '712084066958',
    projectId: 'construmatapp-cma',
    storageBucket: 'construmatapp-cma.appspot.com',
    iosBundleId: 'com.example.construmatapp.RunnerTests',
  );
}