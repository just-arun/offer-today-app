import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offer_today/services/modules/auth_service.dart';
import 'package:offer_today/services/modules/user_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logoutRedirect(BuildContext context, err) async {
  var code = err.statusCode;
  if (code == null) {
    return;
  }
  if (code == 401 || code == 403) {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.of(context).popAndPushNamed("/");
    return;
  }
}

mixin UserMixin {
  void login(BuildContext context, String email, String password) async {
    try {
      final res = await AuthService().login(
        email.trim(),
        password,
      );
      if (res.statusCode == 200) {
        this.getProfile(context).then((res) {
          Navigator.of(context).popAndPushNamed("/home");
          return;
        }).catchError((err) {
          print(err);
          String errorMessage;
          if (err.body != null) {
            errorMessage = jsonDecode(err.body)["error"]["message"];
          } else {
            errorMessage = "error";
          }
          showToast(
            "$errorMessage",
            position: ToastPosition.bottom,
            textPadding: EdgeInsets.all(10.0),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          );
          return;
        });
      } else {
        throw res;
      }
    } catch (err) {
        logoutRedirect(context, err);
      String errorMessage;
      if (err.body != null) {
        errorMessage = jsonDecode(err.body)["error"]["message"];
      }
      showToast(
        "$errorMessage",
        position: ToastPosition.bottom,
        textPadding: EdgeInsets.all(10.0),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      );
    }
  }

  void registerUser(
    BuildContext context,
    String userName,
    String email,
    String password,
  ) async {
    try {
      final res = await AuthService().register(
        userName,
        email.trim(),
        password,
      );
      if (res.statusCode == 201) {
        await this.getProfile(context).then((res) {
          Navigator.of(context).popAndPushNamed("/home");
          return;
        }).catchError((err) {
          final String errorMessage = jsonDecode(err.body)["error"]["message"];
          showToast(
            "$errorMessage",
            position: ToastPosition.bottom,
            textPadding: EdgeInsets.all(10.0),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          );
          return;
        });
      }
      return;
    } catch (err) {
        logoutRedirect(context, err);
      String errorMessage;
      if (err.body != null) {
        errorMessage = jsonDecode(err.body)["error"]["message"];
      }
      showToast(
        "$errorMessage",
        position: ToastPosition.bottom,
        textPadding: EdgeInsets.all(10.0),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      );
      throw err;
    }
  }

  Future updateProfile(
      BuildContext context, String userID, dynamic data) async {
    try {
      final res = await UserService().updateMinilalProfile(userID, data);
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
        logoutRedirect(context, err);
      print(err);
    }
  }

  Future getProfile(
    BuildContext context,
  ) async {
    try {
      final res = await UserService().getProfile();
      print(res.statusCode);
      // print(res.body);
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final data = jsonDecode(res.body)["data"];
        final String did = data["id"];
        final String duserName = data["userName"];
        final String demail = data["email"];
        var dposts = data["posts"];
        final String dregistrationDate = data["registrationDate"];
        final int duserType = data["userType"];
        final String dcretedAt = data["cretedAt"];
        final String imageUrl = data["imageUrl"];
        print(data);
        prefs.setString("uid", did);
        prefs.setString("userName", duserName);
        prefs.setString("email", demail);
        prefs.setString("posts", dposts.toString());
        prefs.setString("registrationDate", dregistrationDate);
        prefs.setInt("userType", duserType);
        prefs.setString("imageUrl", imageUrl);
        prefs.setString("cretedAt", dcretedAt);
      }
      return;
    } catch (err) {
        logoutRedirect(context, err);
      print(err);
      String errorMessage;
      if (err.body != null) {
        errorMessage = jsonDecode(err.body)["error"]["message"];
      }
      showToast(
        "$errorMessage",
        position: ToastPosition.bottom,
        textPadding: EdgeInsets.all(10.0),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      );
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers(
    BuildContext context,
  ) async {
    try {
      final result = await UserService().getAllUsers();
      final json = jsonDecode(result.body)["data"];
      print(json);
      final data = List<Map<String, dynamic>>.from(json);
      return data;
    } catch (err) {
        logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future<Map<String, dynamic>> getOneUser(
      BuildContext context, String id) async {
    try {
      final result = await UserService().getUser(id);
      print(result.body);
      final json = jsonDecode(result.body);
      final Map<String, dynamic> data = json["data"];
      print(data);
      return data;
    } catch (err) {
        logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }
}
