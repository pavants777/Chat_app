import 'package:chatx/Screens/HomePage.dart';
import 'package:chatx/Screens/LoginPage.dart';
import 'package:chatx/Screens/SignInPage.dart';
import 'package:chatx/Screens/StartPage.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static String startPage = '/';
  static String homePage = '/home';
  static String signIn = '/signin';
  static String account = '/account';
  static String logIn = '/login';

  static Map<String, WidgetBuilder> routes = {
    startPage: (context) => StartPage(),
    homePage: (context) => HomePage(),
    signIn: (context) => SignIn(),
    // account: (context) => Account(),
    logIn: (context) => LoginPage(),
  };
}
