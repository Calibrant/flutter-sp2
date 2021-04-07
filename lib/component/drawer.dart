import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
import 'package:flutter_app_sp2/firebase_messaging/application.dart';
import 'package:flutter_app_sp2/firebase_messaging/messaging_example_app.dart';
import 'package:flutter_app_sp2/main.dart';
import 'package:flutter_app_sp2/search.dart';
import '../auth_sms.dart';
import '../const.dart';
import '../googlemap_screen.dart';
import '../provider_page.dart';

class MainMenuBar extends StatelessWidget {
  const MainMenuBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(DRAWER_LIST_TILE_TITLE_MAIN_MENU),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(URL_NETWORK_IMAGE)),
            title: Text(DRAWER_LIST_TILE_TITLE),
            subtitle: Text(DRAWER_MY_EMAIL),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(GOOGLE_MAP_PAGE_APPBAR_TITLE),
            onTap: () {
              Navigator.pushNamed(context, GoogleMapPage.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text(DRAWER_LIST_TILE_TITLE_CHAT),
            onTap: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(DRAWER_LIST_TILE_TITLE_ADD),
            onTap: () {
              Navigator.pushNamed(context, ProviderPage.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Поиск'),
            onTap: () {
              Navigator.pushNamed(context, Search.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('FCM notification'),
            onTap: () {
              Navigator.pushNamed(context, Application.id);
            },
          ),
        ],
      ),
    );
  }
}
