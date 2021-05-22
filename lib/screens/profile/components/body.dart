import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/screens/notification/notification_screen.dart';
import 'package:shop_app/screens/profile/settings/settings.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  _signOut() async {}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {
              Navigator.pushNamed(context, NotificationsPage.routeName);
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false);
              Future.delayed(Duration(seconds: 2), () {
                Auth.add(LogOut());
              });
            },
          ),
        ],
      ),
    );
  }
}
