import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';

class AccountBody extends StatefulWidget {
  @override
  PopularProductsState createState() => PopularProductsState();
}

class PopularProductsState extends State<AccountBody> {
  bool isLoading = true;
  Future<QuerySnapshot> _future;
  QuerySnapshot snapshot;
  List orderList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("vendorproduct")
            .doc('accounts')
            .collection(Auth.state.user.address)
            .snapshots(),
        builder: (contexts, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              orderList.clear();
              snapshot.data.docs.forEach((result) {
                Product pp = Product.fromJson(result.data());
                orderList.add(pp);
              });
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 5),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Card(
                                            elevation: 4,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "N 0",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              20),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Total Account Daily",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              13),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: Card(
                                            elevation: 4,
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    " N 0",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              20),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Total Account Monthly",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              13),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: getProportionateScreenWidth(20)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                "Transactions",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(20)),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  (snapshot.data.docs.isEmpty)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 100),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          20)),
                                              child: Text(
                                                "Oops !! No transactions yet, try adding items to inventory, the more items you have the more transactions you would have",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          15),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                return Container();
                                              }),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
