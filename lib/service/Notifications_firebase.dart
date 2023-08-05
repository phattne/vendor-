
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print('title : ${message.notification?.title ?? "No title"}');
      print('body : ${message.notification?.body ?? "No body"}');
    }
    print('payload : ${message.data}');
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    if (message.notification != null) {
      String title = message.notification!.title ?? "No title";
      String body = message.notification!.body ?? "No body";
      
     
    }
  }

  Future<void> inheritedNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
  }
}
