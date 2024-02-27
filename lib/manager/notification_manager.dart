import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:foap/apiHandler/api_controller.dart';
import 'package:foap/apiHandler/apis/chat_api.dart';
import 'package:foap/controllers/agora_call_controller.dart';
import 'package:foap/controllers/live/agora_live_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/call_model.dart';
import 'package:foap/screens/chat/chat_detail.dart';
import 'package:foap/screens/competitions/competition_detail_screen.dart';
import 'package:foap/screens/home_feed/comments_screen.dart';
import 'package:foap/screens/profile/other_user_profile.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import '../apiHandler/apis/users_api.dart';
import '../util/shared_prefs.dart';

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
          _parseNotificationMessage(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
    // With this token you can test it easily on your phone
    _firebaseMessaging.getToken().then((fcmToken) {
      if (fcmToken != null) {
        SharedPrefs().setFCMToken(fcmToken);
      }
    });

    _firebaseMessaging.onTokenRefresh.listen((fcmToken) {
      SharedPrefs().setFCMToken(fcmToken);
    }).onError((err) {});
  }

  _parseNotificationMessage(Map<String, dynamic>? notificationData) {
    // Parse the notification message data here
    // You can extract specific fields or perform any other parsing logic
    // For example:
    if (notificationData != null) {
      String? title = notificationData['title'];
      String? body = notificationData['body'];
      // Handle other fields as needed
    }
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}

class NotificationManager {
  static final NotificationManager _singleton = NotificationManager._internal();

  factory NotificationManager() {
    return _singleton;
  }

  NotificationManager._internal();

  initialize() {
    // Initialize Awesome Notifications
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'calls',
          channelName: 'Calls',
          channelDescription: 'Notifications for incoming calls',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );

    // Set up notification handlers
    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   if (receivedNotification.buttonKeyPressed == "answer") {
    //     _actionOnCall(receivedNotification.payload!, true);
    //   } else if (receivedNotification.buttonKeyPressed == "decline") {
    //     _actionOnCall(receivedNotification.payload!, false);
    //   }
    // });
  }

  _actionOnCall(Map<String, String?> data, bool accept) {
    final AgoraCallController agoraCallController = Get.find();
    String channelName = data['channelName']!;
    String token = data['token']!;
    String callType = data['callType']!;
    String id = data['id']!;
    String uuid = data['uuid']!;
    String callerId = data['callerId']!;

    UsersApi.getOtherUser(
      userId: int.parse(callerId),
      resultCallback: (result) {
        Call call = Call(
          uuid: uuid,
          channelName: channelName,
          isOutGoing: true,
          opponent: result,
          token: token,
          callType: int.parse(callType),
          callId: int.parse(id),
        );

        if (accept) {
          agoraCallController.acceptCall(call: call);
        } else {
          agoraCallController.declineCall(call: call);
        }
      },
    );
  }
}

class AwesomeNotificationController {
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }
}
