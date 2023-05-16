import 'dart:convert';

import 'package:accurate_laboratory/login/data/data_source/fcm_token_data.dart';
import 'package:accurate_laboratory/shared/presentation/screens/appoitment_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../complete/presentation/screens/complete_screen.dart';
import '../../../constants.dart';
import '../../../login/data/data_source/staff_shared_pref.dart';
import '../../../login/presentation/screens/login_screen.dart';
import '../../../ongoing/presentation/screens/ongoing_screen.dart';
import '../../../open/presentation/screens/open_screen.dart';
import '../../../shared/services/notification_service.dart';
import '../../../splash/presentation/screen/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  final String staffId;
  const HomeScreen({Key? key, required this.staffId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = 0;
  // getFcmToken() async {
  //   String? fcmToken = await FirebaseMessaging.instance.getToken();
  // }

  var notificationService = NotificationService();
  getNotification() {
    notificationService.initialize(
      onReciveNotification: (notificationResponse) async {
        final String payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: $payload');
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AppoitmentDetailScreen(appoitmentId: payload),
            ),
          );
        } else {
          print('Error');
        }
      },
    );
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if (message.data['id'] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppoitmentDetailScreen(
                  appoitmentId: message.data['id'].toString(),
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('Appointments'),
              ),
              titleTextStyle: TextStyle(fontSize: 18),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => AlertDialog(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to Logout?'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: secondaryColor),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                var loginPref = LoginSharedPrefrance();
                                await loginPref.removeToken();
                                var loginToken = LoginSharedPrefrance();
                                await loginToken.removeToken();
                                setState(() {
                                  removeFcmToken('', widget.staffId);
                                });

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (Route route) => false,
                                );
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              bottom: const TabBar(indicatorColor: secondaryColor, tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Open'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Ongoing'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Completed'),
                ),
              ]),
            ),
          ),
          body: TabBarView(
            children: [
              OpenScreen(staffId: widget.staffId),
              OnGoingScreen(
                staffId: widget.staffId,
              ),
              CompleteScreen(
                staffId: widget.staffId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
