import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/account/body.dart';
import 'package:shop_app/size_config.dart';

class Accounts extends StatelessWidget {
  static String routeName = "/accounts";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Accounts",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(child: AccountBody())
          ],
        ),
      )),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.account),
    );
  }
}
