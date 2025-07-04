// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBEHWAoKRhSe-7ZUQzzAKC6YWyax9frfX0',
    appId: '1:90715984350:web:8d36b30e5187a83b9d0d4f',
    messagingSenderId: '90715984350',
    projectId: 'may-iot',
    authDomain: 'may-iot.firebaseapp.com',
    storageBucket: 'may-iot.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNsVv0lCM_-Q4DhSwYeTYIEeTQdvRLjk0',
    appId: '1:90715984350:ios:d53abec2d8f9ab129d0d4f',
    messagingSenderId: '90715984350',
    projectId: 'may-iot',
    storageBucket: 'may-iot.appspot.com',
    iosBundleId: 'com.example.mayIot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNsVv0lCM_-Q4DhSwYeTYIEeTQdvRLjk0',
    appId: '1:90715984350:ios:d53abec2d8f9ab129d0d4f',
    messagingSenderId: '90715984350',
    projectId: 'may-iot',
    storageBucket: 'may-iot.appspot.com',
    iosBundleId: 'com.example.mayIot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBEHWAoKRhSe-7ZUQzzAKC6YWyax9frfX0',
    appId: '1:90715984350:web:cf3567b47deeaeae9d0d4f',
    messagingSenderId: '90715984350',
    projectId: 'may-iot',
    authDomain: 'may-iot.firebaseapp.com',
    storageBucket: 'may-iot.appspot.com',
  );
}
