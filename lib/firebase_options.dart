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
    apiKey: 'AIzaSyASocO5Y3Y2KdXwUnVMefHbgbQ2SFed0W4',
    appId: '1:489434370331:web:a768d3b1768213a06b03be',
    messagingSenderId: '489434370331',
    projectId: 'financehub-925f3',
    authDomain: 'financehub-925f3.firebaseapp.com',
    storageBucket: 'financehub-925f3.appspot.com',
    measurementId: 'G-D83H76EMZ0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1anL2mXMYc3GR2cxZKJ59pOmPFlk4e9c',
    appId: '1:489434370331:android:cd66ebd66ef005f26b03be',
    messagingSenderId: '489434370331',
    projectId: 'financehub-925f3',
    storageBucket: 'financehub-925f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ-6UntVcf8esWAe1M9pY5hdI887ExReg',
    appId: '1:489434370331:ios:a5aba063f9247d646b03be',
    messagingSenderId: '489434370331',
    projectId: 'financehub-925f3',
    storageBucket: 'financehub-925f3.appspot.com',
    iosClientId: '489434370331-6lnkrehebvisoalqi5cilk9q9reusopl.apps.googleusercontent.com',
    iosBundleId: 'com.example.aplicacaoFinanceira',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ-6UntVcf8esWAe1M9pY5hdI887ExReg',
    appId: '1:489434370331:ios:4eb2dd7459f5b72f6b03be',
    messagingSenderId: '489434370331',
    projectId: 'financehub-925f3',
    storageBucket: 'financehub-925f3.appspot.com',
    iosClientId: '489434370331-2pivuoukpearsdbq9dtodmn9fbfgep6m.apps.googleusercontent.com',
    iosBundleId: 'com.example.aplicacaoFinanceira.RunnerTests',
  );
}
