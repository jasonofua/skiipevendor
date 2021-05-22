import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database.dart';

import '../../../size_config.dart';

class AddItem extends StatefulWidget {
  static String routeName = "/additem";
  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  File _image;
  String title;
  String desc;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String price;
  final List<String> errors = [];
  final picker = ImagePicker();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyComplete =
      new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyAddItem');

  void showInSnackBar(String value) {
    _scaffoldKeyComplete.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyComplete,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Product',
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenWidth(30)),
                (_image == null)
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            fit: StackFit.expand,
                            overflow: Overflow.visible,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    child: GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ),
                      ),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildLastNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPhoneNumberFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildAddressFormField(),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(30)),
                DefaultButton(
                  text: "Add Item",
                  press: () async {
                    if (_image != null) {
                      var rng = new Random();
                      try {
                        showInSnackBar("Adding Product...please wait");
                        Reference referenceAvatar = _firebaseStorage
                            .ref()
                            .child("vendorsFeature")
                            .child("vendorP")
                            .child(_image.path.toString());
                        UploadTask uploadTaskAvatar =
                            referenceAvatar.putFile(_image);
                        var imageUrlAvatar =
                            await (await uploadTaskAvatar).ref.getDownloadURL();

                        Map<String, dynamic> userDataMap = {
                          "id": rng.nextInt(100),
                          "title": title,
                          "description": desc,
                          "images": imageUrlAvatar.toString(),
                          "rating": 0.0,
                          "price": int.parse(price),
                          "isFavourite": false,
                          "isPopular": true,
                        };

                        Map<String, dynamic> notification = {
                          "name": title,
                        };

                        await DatabaseMethods().addVendorProduct(
                            userDataMap, Auth.state.user.address);
                        await DatabaseMethods().addNotifiction(
                            notification, Auth.state.user.address);
                        Navigator.pop(context);
                      } catch (e) {
                        addError(error: e.toString());
                      }
                    } else {
                      showInSnackBar(
                          "please select a feature image for the shop");
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter Product Title",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value) {
        setState(() {
          desc = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Product Description",
        hintText: "Enter product description",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          price = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Product Price",
        hintText: "Enter Product Price",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
