import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
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
            decoration: BoxDecoration(color: Colors.blue),
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
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text(DRAWER_LIST_TILE_TITLE_CHAT),
            onTap: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(DRAWER_LIST_TILE_TITLE_ADD),
            onTap: () {
              Navigator.pushNamed(context, ProviderPage.id);
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
