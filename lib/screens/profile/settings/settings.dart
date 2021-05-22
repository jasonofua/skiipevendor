import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/profile/settings/change_password_page.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(color: kPrimaryColor),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
            builder: (builder, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'General',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          ListTile(
                              title: Text('Change Password'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.pushNamed(
                                  context, ChangePasswordPage.routeName)),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
