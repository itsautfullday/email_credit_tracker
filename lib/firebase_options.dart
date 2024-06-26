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
    apiKey: 'AIzaSyDEk36Y16q7geAoWGqkzySZ9x9p_pZXH0Y',
    appId: '1:1080629874940:web:8089973add0ed976a54779',
    messagingSenderId: '1080629874940',
    projectId: 'simple-debit-manager',
    authDomain: 'simple-debit-manager.firebaseapp.com',
    storageBucket: 'simple-debit-manager.appspot.com',
    measurementId: 'G-D91NVSKDL9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA227r9bLj0LqmNve_xBTlTGEcjUBdSHIA',
    appId: '1:1080629874940:android:538f5027575ffb7ea54779',
    messagingSenderId: '1080629874940',
    projectId: 'simple-debit-manager',
    storageBucket: 'simple-debit-manager.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmIvDRzc5gkuN4c21GnuX0yrxEDpsFWGw',
    appId: '1:1080629874940:ios:c9af20b99e70ecfda54779',
    messagingSenderId: '1080629874940',
    projectId: 'simple-debit-manager',
    storageBucket: 'simple-debit-manager.appspot.com',
    iosClientId: '1080629874940-pe8e00mabf2e9416vdl2r1tlm83uk4ev.apps.googleusercontent.com',
    iosBundleId: 'com.example.emailCreditTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmIvDRzc5gkuN4c21GnuX0yrxEDpsFWGw',
    appId: '1:1080629874940:ios:74c542029737cd2ba54779',
    messagingSenderId: '1080629874940',
    projectId: 'simple-debit-manager',
    storageBucket: 'simple-debit-manager.appspot.com',
    iosClientId: '1080629874940-248ge3bk8ugcr24uiuj3nu9nmin6lh5r.apps.googleusercontent.com',
    iosBundleId: 'com.example.emailCreditTracker.RunnerTests',
  );
}
