import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/notification/body.dart';

class NotificationsPage extends StatelessWidget {
  static String routeName = "/notification";
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Notification',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CloseButton()
                ],
              ),
              Expanded(child: NotificationBody())
            ])),
      ),
    );
  }
}
