import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/orders/body.dart';
import 'package:shop_app/size_config.dart';

class Orders extends StatelessWidget {
  static String routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Orders",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(child: OrderBody())
          ],
        ),
      )),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.order),
    );
  }
}
