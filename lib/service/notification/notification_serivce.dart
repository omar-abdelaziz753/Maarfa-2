import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../local/share_prefs_service.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var initialzationSettingsAndroid =
      const AndroidInitializationSettings("logo");
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            priority: Priority.max,
            enableLights: true,
            playSound: true,
          ),
        ));
  }
}

class NotificationService {
  SharedPrefService prefs = SharedPrefService();
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService? get instance => _instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? _localNotificationsPlugin;
  NotificationService._internal();
  static bool firstRun = true;
  // GlobalKey<NavigatorState> _navKey;
  Future<String?> getToken() {
    return _messaging.getToken();
  }

  Future<void> subscripeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscripeToTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> initNotificationService() async {
    // _navKey = GlobalKey(debugLabel: "Main Navigator");
    await _initFirebaseMessaging();
    _initLocalNotifications();
    _checkForInitialMessage();
  }

  Future<void> _initLocalNotifications() async {
    debugPrint("init local notifications");
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidSettings = const AndroidInitializationSettings(
      "logo",
    );
    var iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotificationsPlugin!.initialize(
      settings,
      // onSelectNotification: (payload) async {
      //   debugPrint("notification pressed");
      //   // if (!firstRun) {
      //   // final payloadMap = jsonDecode(payload);
      //   // if (payloadMap.contain("target_id")) {
      //   // TripModel tripModel = TripModel();
      //   // tripModel.id = payloadMap['trip']['id'];
      //   // tripModel.driver = Driver.fromMap(payloadMap['trip']['driver']);
      //   // Get.to(() => kawidOrderDetailsScreen(id: 22));
      //   // debugPrint(22);
      //   // }
      //   // }
      // },
    );

    firstRun = false;
  }

  Future<void> _initFirebaseMessaging() async {
    debugPrint("init firebase messaging");
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // final payloadMap = jsonDecode(message);
        // if (payloadMap.contain("target_id")) {
        // TripModel tripModel = TripModel();
        // tripModel.id = payloadMap['trip']['id'];
        // tripModel.driver = Driver.fromMap(payloadMap['trip']['driver']);
        // Get.to(() => MainScreen());
        debugPrint("id: ${message.data["target_id"]}");
        log('notifiationonMessageOpenedApp');
        // }
        // }
      });
      debugPrint('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // final payloadMap = jsonDecode(json.encode(message));
        // if (payloadMap.contain("target_id")) {
        // TripModel tripModel = TripModel();
        // tripModel.id = payloadMap['trip']['id'];
        // tripModel.driver = Driver.fromMap(payloadMap['trip']['driver']);
        // Get.to(() => MainScreen());
        // debugPrint(23);
        // }
        // }
        // Parse the message received
        log('notifiationonMessagep');

        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          sound: "default",
        );

        // if (notification != null) {
        await showLocalNotification(
            notification.title!, notification.body!, '');
        // }
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // _messaging.getNotificationSettings();
    //   onMessage: (Map<String, dynamic> map) async {
    //     debugPrint(map);
    //     Map notification;
    //     if (map['notification'] == null) {
    //       notification = map['aps']['alert'];
    //     } else {
    //       notification = map['notification'];
    //     }
    //     await showLocalNotification(
    //         notification['title'], notification['body'], null);
    //   },
    //   onLaunch: (message) async {
    //     debugPrint("i'm launced");
    //     debugPrint(message);
    //   },
    //   onResume: (message) async {
    //     debugPrint("message resume :$message");
    //   },
    // );
  }

  _checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        sound: "default",
      );
      debugPrint(notification.body.toString());
    }
  }

  // Future<Option<Failure>> deleteToken() async {
  //   final result = await _messaging.deleteInstanceID();
  //   if (!result) return some(Failure("server-error"));
  //   return none();
  // }

  Future<void> showLocalNotification(
      String title, String body, String payload) async {
    debugPrint("showing ....");
    var androidDetails = const AndroidNotificationDetails("1", "chats",
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false,
        styleInformation: BigTextStyleInformation(''));
    var iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _localNotificationsPlugin!.show(1, title, body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload);
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.sound,
  });
  String? title;
  String? body;
  String? sound;
}
