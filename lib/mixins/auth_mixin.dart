import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthMixin {
  Future<bool> isUserLogedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("accessToken");
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> viewOnlyUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userType = prefs.getInt("userType");
    final bool view = userType == 0;
    if (view) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> userStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userType = prefs.getInt("userType");
    return userType;
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return;
  }

  void isLogedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasToken = prefs.getString("accessToken") != null;
    print(hasToken);
    if (!hasToken) {
      Navigator.of(context).popAndPushNamed("/");
    } else
      ;
  }

  void isUserLoggedin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasToken = prefs.getString("accessToken") != null;
    if (hasToken) {
      Navigator.of(context).popAndPushNamed("/home");
    } else
      ;
  }
  
}
