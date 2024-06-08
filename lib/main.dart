import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/controller/driverstatus_provider.dart';
import 'package:first_choice_driver/controller/login_provider.dart';
import 'package:first_choice_driver/controller/profile_provider.dart';
import 'package:first_choice_driver/controller/ride_history.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/controller/signup_provider.dart';
import 'package:first_choice_driver/model/riderequestnoti.dart';
import 'package:first_choice_driver/notification.dart';
import 'package:first_choice_driver/screens/paymentscreen.dart';
import 'package:first_choice_driver/screens/splashscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getToken().then((value) {
    print("token is $value");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the notification message when the app is in the foreground
    print('Message clicked: ${message.notification!.body}');
  });

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(
      // DevicePreview(builder: (context) {
      //   return
      const MyApp()
      // }),
      );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    initnotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.instance.showNotification(message);

      // Handle the received notification message
      log("Message data is ${message.data}");
      var riderequest = RideRequestModel.fromJson((message.data));
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => PagesWidget(
            isriderecieved: true,
            rideRequestModel: riderequest,
          ),
        ),
      );
      print(riderequest.customerId);
    });
    super.initState();
  }

  Future<void> initnotification() async {
    await LocalNotification.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DriverStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RideHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RideProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Driver App',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(
            // endRide: ,
            // markers: ,
            ),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  message.data;
  LocalNotification.instance.showNotification(message);

  print(
    "Handling a background message: ${message.notification}",
  );
}
