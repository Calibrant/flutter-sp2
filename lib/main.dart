import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/provider_page.dart';
import 'auth_sms.dart';
import 'chat/screens/chat_screen.dart';
import 'chat/screens/login_screen.dart';
import 'chat/screens/registration_screen.dart';
import 'chat/screens/welcome_screen.dart';
import 'const.dart';
import 'googlemap_screen.dart';
import 'theme/theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(TabBarDemo());
  runApp(MyApp());
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
        initialRoute: AuthSms.id,
        routes: {
          AuthSms.id: (context) => AuthSms(),
          GoogleMapPage.id: (context) => GoogleMapPage(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ProviderPage.id: (context) => ProviderPage(),
        },
        title: AUTH_SMS_TITLE,
      
        home: AuthSms(),
      ),
    );
  }
}
