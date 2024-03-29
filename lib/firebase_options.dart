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
    apiKey: 'AIzaSyCdPBwJe_Cuxo6kZRCykGQDtmm_scnW5b8',
    appId: '1:564900138715:web:63a4b14d8f1cd89aadc6fe',
    messagingSenderId: '564900138715',
    projectId: 'foodconnect-9600c',
    authDomain: 'foodconnect-9600c.firebaseapp.com',
    storageBucket: 'foodconnect-9600c.appspot.com',
    measurementId: 'G-CCLCNN5TYF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAn4UhyAHhE_5KG_0tF_20ypWMksA0v3Ps',
    appId: '1:564900138715:android:6cdc9013e2eca3d2adc6fe',
    messagingSenderId: '564900138715',
    projectId: 'foodconnect-9600c',
    storageBucket: 'foodconnect-9600c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqZMOATL0aj8C_cFikop6zz7tkRmE_wK4',
    appId: '1:564900138715:ios:aea7ac2498d8bb48adc6fe',
    messagingSenderId: '564900138715',
    projectId: 'foodconnect-9600c',
    storageBucket: 'foodconnect-9600c.appspot.com',
    iosBundleId: 'com.example.foodconnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqZMOATL0aj8C_cFikop6zz7tkRmE_wK4',
    appId: '1:564900138715:ios:771eef6697ced0ebadc6fe',
    messagingSenderId: '564900138715',
    projectId: 'foodconnect-9600c',
    storageBucket: 'foodconnect-9600c.appspot.com',
    iosBundleId: 'com.example.foodconnect.RunnerTests',
  );
}
