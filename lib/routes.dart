import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/account/accounts.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/components/add_item.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/home/itembigview/moreitems.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/notification/notification_screen.dart';
import 'package:shop_app/screens/orders/orders.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/profile/settings/change_password_page.dart';
import 'package:shop_app/screens/profile/settings/settings.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/signup_success/signup_success_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignupSuccessScreen.routeName: (context) => SignupSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  NotificationsPage.routeName: (context) => NotificationsPage(),
  SettingsPage.routeName: (context) => SettingsPage(),
  ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
  MoreItems.routeName: (context) => MoreItems(),
  Orders.routeName: (context) => Orders(),
  Accounts.routeName: (context) => Accounts(),
  AddItem.routeName: (context) => AddItem(),
};
