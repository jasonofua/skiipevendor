import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/database.dart';
import 'package:shop_app/models/shop.dart' as uss;
import 'package:shop_app/screens/signup_success/signup_success_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String category;
  String lastName;
  String phoneNumber;
  String address;
  String bio;
  final _auth = FirebaseAuth.instance;
  String uid = '';
  String email = '';
  bool _isLoading = false;
  File _image;
  final picker = ImagePicker();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final GlobalKey<ScaffoldState> _scaffoldKeyComplete =
      new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyComplete');

  void showInSnackBar(String value) {
    _scaffoldKeyComplete.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void getCurrentUser() {
    final User user = _auth.currentUser;
    uid = user.uid;
    email = user.email;
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

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: Auth,
      listener: (context, state) {
        if (state is Authenticated)
          Navigator.pushNamed(context, SignupSuccessScreen.routeName);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          key: _scaffoldKeyComplete,
          body: ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildFeaturedImage(),
                        buildFirstNameFormField(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildLastNameFormField(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildPhoneNumberFormField(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildAddressFormField(),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 45,
                            margin: EdgeInsets.only(top: 32),
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Category',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: category,
                                          items: <String>[
                                            'Food',
                                            'Gadgets',
                                            'Clothing',
                                            'Automobile'
                                          ].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              category = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        Text(
                          "By continuing your confirm that you agree \nwith our Term and Condition",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: getProportionateScreenHeight(40)),
                        DefaultButton(
                          text: "continue",
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              if (_image != null) {
                                try {
                                  showInSnackBar(
                                      "Completing registration...please wait");
                                  Reference referenceAvatar = _firebaseStorage
                                      .ref()
                                      .child("vendorsFeature")
                                      .child(firstName)
                                      .child(_image.path.toString());
                                  UploadTask uploadTaskAvatar =
                                      referenceAvatar.putFile(_image);
                                  var imageUrlAvatar =
                                      await (await uploadTaskAvatar)
                                          .ref
                                          .getDownloadURL();
                                  String urlAvatar = imageUrlAvatar.toString();
                                  Map<String, dynamic> userDataMap = {
                                    "name": '${firstName}',
                                    "email": email,
                                    "wallet": '0',
                                    "address": address,
                                    "phone": phoneNumber,
                                    "isOnline": true,
                                    "uid": uid,
                                    "imageUrl": urlAvatar,
                                    "bio": bio
                                  };

                                  await DatabaseMethods()
                                      .addVendorInfo(userDataMap, uid);
                                  DocumentSnapshot userInfoSnapshot =
                                      await DatabaseMethods()
                                          .getVendorInfo(uid);
                                  print("ere ${userInfoSnapshot.data()}");
                                  uss.Shop users = uss.Shop.fromJson(
                                      userInfoSnapshot.data());
                                  Auth.add(LoggedIn(users, uid));
                                } catch (e) {
                                  addError(error: e.toString());
                                }
                              } else {
                                showInSnackBar(
                                    "please select a feature image for the shop");
                              }
                            }
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Padding buildFeaturedImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 15),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Featured shop image",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Muli",
                      color: Color(0xff343434),
                      fontWeight: FontWeight.normal)),
            ),
          ),
          GestureDetector(
            onTap: getImage,
            child: Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: _image == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.upload_rounded,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 17,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Tap To Upload",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: "Muli",
                                        color: Color(0xff343434),
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onSaved: (newValue) => bio = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "About",
        hintText: "Short note about shop",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Shop Phone Number",
        hintText: "Enter shop phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      decoration: InputDecoration(
        labelText: "Shop Address",
        hintText: "Enter shop address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Shop Name",
        hintText: "Enter your shop name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/shop.svg"),
      ),
    );
  }
}
