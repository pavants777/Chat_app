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
    apiKey: 'AIzaSyDXFc2DbQEKLvL-xwimVnVLH_s4tobZSoU',
    appId: '1:1034664091178:web:3f02ad86ae14701d1eed53',
    messagingSenderId: '1034664091178',
    projectId: 'chat-7771d',
    authDomain: 'chat-7771d.firebaseapp.com',
    storageBucket: 'chat-7771d.appspot.com',
    measurementId: 'G-0YJKX4FKVN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxMmXYtPG0zSS4pEiuAq_-Ae8q9Cpji2o',
    appId: '1:1034664091178:android:ee29523f494ea6191eed53',
    messagingSenderId: '1034664091178',
    projectId: 'chat-7771d',
    storageBucket: 'chat-7771d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBawTg7nTYFazs8f_mxWhsYRK4-SS86_sA',
    appId: '1:1034664091178:ios:b7713827c63be0f71eed53',
    messagingSenderId: '1034664091178',
    projectId: 'chat-7771d',
    storageBucket: 'chat-7771d.appspot.com',
    iosBundleId: 'com.example.chatx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBawTg7nTYFazs8f_mxWhsYRK4-SS86_sA',
    appId: '1:1034664091178:ios:e18f5114399a68b71eed53',
    messagingSenderId: '1034664091178',
    projectId: 'chat-7771d',
    storageBucket: 'chat-7771d.appspot.com',
    iosBundleId: 'com.example.chatx.RunnerTests',
  );
}
