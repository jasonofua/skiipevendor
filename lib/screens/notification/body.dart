import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class NotificationBody extends StatefulWidget {
  @override
  PopularProductsState createState() => PopularProductsState();
}

class PopularProductsState extends State<NotificationBody> {
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
            .doc('notification')
            .collection(Auth.state.user.address)
            .snapshots(),
        builder: (contexts, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
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
                                                "Oops !! No Notification yet",
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
                                                return Card(
                                                    elevation: 4,
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                bottom: 30),
                                                        child:
                                                            Column(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  'New Item added to inventory',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10)),
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.0),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Text(
                                                                'A new item with name: ${snapshot.data.docs[index]['name']} was added to your inventory',
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        13)),
                                                          )
                                                        ]),
                                                      ),
                                                    ));
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
