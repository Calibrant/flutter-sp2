import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/firebase_messaging/application.dart';
import '../main.dart';
import 'message.dart';

class MessagingExampleApp extends StatelessWidget {
  static const String id = 'message_example_app';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => Application(),
        '/message': (context) => MessageView(),
      },
    );
  }
}