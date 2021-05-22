import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/itembigview/components/special_offers_more.dart';

import '../../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text("More Items"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              SpecialOffersMore(type: "Nokia"),
              SizedBox(height: getProportionateScreenWidth(10)),
              SpecialOffersMore(type: "Techno"),
              SizedBox(height: getProportionateScreenWidth(10)),
              SpecialOffersMore(type: "Redmi"),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
