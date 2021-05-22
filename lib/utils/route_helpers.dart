import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteHelpers {
  static Future<Widget> toPageDirect(NavigatorState nav, page,
      {bool replace = false}) async {
    if (Platform.isAndroid) {
      if (replace) {
        return await nav
            .pushReplacement(new MaterialPageRoute(builder: (context) {
          return page;
        }));
      } else {
        return await nav.push(new MaterialPageRoute(builder: (context) {
          return page;
        }));
      }
    } else {
      if (replace) {
        return await nav
            .pushReplacement(new CupertinoPageRoute(builder: (context) {
          return page;
        }));
      } else {
        return await nav.push(new CupertinoPageRoute(builder: (context) {
          return page;
        }));
      }
    }
  }

  static Future<Widget> toPage(GlobalKey<NavigatorState> nav, page,
      {bool replace = false}) async {
    toPageDirect(nav.currentState, page, replace: replace);
  }
}
