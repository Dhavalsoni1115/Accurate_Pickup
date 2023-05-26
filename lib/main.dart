// @dart=2.9
import 'dart:async';
import 'package:accurate_laboratory/shared/services/notification_service.dart';
import 'package:accurate_laboratory/splash/presentation/screen/splash_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'home/presentation/screens/home_screen.dart';
import 'login/data/data_source/staff_shared_pref.dart';
import 'login/presentation/screens/login_screen.dart';

String token;
var notificationService = NotificationService();
@pragma('vm:entry point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification.title.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var token;
  getToken() async {
    var sharedPref = LoginSharedPrefrance();
    token = await sharedPref.getLoginToken();
    setState(() {
      token;
    });
    return token;
  }

  @override
  void initState() {
    super.initState();
    getToken() ?? null;
    notificationService.requestNotificationPermission();
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification.title);
          print(message.notification.body);
          print(message.data['id'].toString());
          print("message.data11 ${message.data}");
          notificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification.title);
          print(message.notification.body);
          print("message.data22 ${message.data}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor, // Note RED here
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null
          ? HomeScreen(staffId: token.toString())
          : AnimatedSplashScreen(
              backgroundColor: backgroundColor,
              splash: const SplashScreen(),
              nextScreen: const LoginScreen(),
              duration: 1000,
              splashTransition: SplashTransition.fadeTransition,
            ),
    );
  }
}
