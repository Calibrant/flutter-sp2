import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/firebase_messaging/application.dart';
import 'package:flutter_app_sp2/provider_page.dart';
import 'package:flutter_app_sp2/search.dart';
import 'auth_sms.dart';
import 'chat/screens/chat_screen.dart';
import 'chat/screens/login_screen.dart';
import 'chat/screens/registration_screen.dart';
import 'chat/screens/welcome_screen.dart';
import 'const.dart';
import 'firebase_messaging/message.dart';
import 'firebase_messaging/message_list.dart';
import 'firebase_messaging/messaging_example_app.dart';
import 'firebase_messaging/meta_card.dart';
import 'firebase_messaging/permissions.dart';
import 'firebase_messaging/token_monitor.dart';
import 'googlemap_screen.dart';
import 'provider_page2.dart';
import 'theme/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

int _messageCount = 0;
String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        darkTheme: dark,
        theme: light,
        initialRoute: Application.id,
        routes: {
          AuthSms.id: (context) => AuthSms(),
          GoogleMapPage.id: (context) => GoogleMapPage(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ProviderPage.id: (context) => ProviderPage(),
          ProviderPageDetails.id: (context) => ProviderPageDetails(),
          Search.id: (context) => Search(),
          //MessagingExampleApp.id: (context) => MessagingExampleApp(),
          Application.id: (context) => Application(),
          MessageView.id: (context) => MessageView(),
        },
        title: AUTH_SMS_TITLE,
        home: AuthSms(),
      ),
    );
  }
}



/// The API endpoint here accepts a raw FCM payload for demonstration purposes.

