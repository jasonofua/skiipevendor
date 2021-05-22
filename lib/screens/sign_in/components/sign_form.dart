import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_app/bloc_provider/auth_bloc.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/database.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/models/shop.dart' as uss;
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  final List<String> errors = [];

  final GlobalKey<ScaffoldState> _scaffoldKeyLogin =
      new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyLogin');

  void showInSnackBar(String value) {
    _scaffoldKeyLogin.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: Auth,
      listener: (context, state) {
        if (state is Authenticated)
          Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: 350,
          child: Scaffold(
            key: _scaffoldKeyLogin,
            body: ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildEmailFormField(),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      buildPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Row(
                        children: [
                          Checkbox(
                            value: remember,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                remember = value;
                              });
                            },
                          ),
                          Text("Remember me"),
                          Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, ForgotPasswordScreen.routeName),
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      FormError(errors: errors),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      DefaultButton(
                        text: "Continue",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // if all are valid then go to success screen
                            KeyboardUtil.hideKeyboard(context);
                            try {
                              showInSnackBar('Login in please wait..');
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (user != null) {
                                DocumentSnapshot userInfoSnapshot =
                                    await DatabaseMethods()
                                        .getVendorInfo(user.user.uid);
                                print(userInfoSnapshot.data());
                                uss.Shop users =
                                    uss.Shop.fromJson(userInfoSnapshot.data());
                                Auth.add(LoggedIn(users, user.user.uid));
                              }
                            } on FirebaseAuthException catch (e) {
                              addError(error: e.message);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
