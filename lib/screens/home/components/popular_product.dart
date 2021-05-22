import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  @override
  PopularProductsState createState() => PopularProductsState();
}

class PopularProductsState extends State<PopularProducts> {
  List<Asset> images = List<Asset>();
  bool isLoading = true;
  String _error = 'No Error Dectected';
  Future<QuerySnapshot> _future;
  QuerySnapshot snapshot;
  List productList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: kPrimaryColor.toString(),
          actionBarTitle: "Skiipe",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("vendorproduct")
            .doc('products')
            .collection(Auth.state.user.address)
            .snapshots(),
        builder: (contexts, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              productList.clear();
              snapshot.data.docs.forEach((result) {
                Product pp = Product.fromJson(result.data());
                productList.add(pp);
              });
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: SectionTitle(title: "Inventory", press: () {}),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          productList.length,
                          (index) {
                            if (snapshot.data.docs[index].data()['isPopular'])
                              return ProductCard(product: productList[index]);

                            return SizedBox
                                .shrink(); // here by default width and height is 0
                          },
                        ),
                        SizedBox(width: getProportionateScreenWidth(20)),
                      ],
                    ),
                  )
                ],
              );
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
