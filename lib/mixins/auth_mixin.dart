import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthMixin {
  Future<bool> isUserLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("accessToken");
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> viewOnlyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userType = prefs.getInt("userType");
    final bool view = userType == 0;
    if (view) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> userStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userType = prefs.getInt("userType");
    return userType;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return;
  }

  void isLogedin(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String accessToken = prefs.getString("accessToken");
    // print("$accessToken realy: ${accessToken == null}");
    // if (accessToken == null) {
    //   Navigator.of(context).popAndPushNamed("/");
    // }
    return;
  }

  void isNotLogedin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString("accessToken");
    print(accessToken);
    if (accessToken == null) {
      return;
    } else {
      Navigator.of(context).pushNamed("/home");
      return;
    }
  }
}
