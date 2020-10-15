import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/util/rout-navigation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  String baseUrl = Config.baseUrl;
  String accessToken;
  String refreshToken;

  HttpService() {}

  Future<Map<String, String>> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("accessToken");
    String refreshToken = prefs.getString("refreshToken");
    return {
      "a": accessToken,
      "r": refreshToken,
    };
  }

  Future<bool> _updateToken() async {
    try {
      final res = await http.patch(
        "${this.baseUrl}/auth/refresh-token",
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, String>{
            "refreshToken": this.refreshToken,
          },
        ),
      );
      if (res.statusCode == 200) {
        var access = json.decode(res.body)["accessToken"];
        var refresh = json.decode(res.body)["refreshToken"];
        this._setTokens(access, refresh);
        return true;
      }
    } catch (err) {
      if (err.statusCode == 403) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        NavigationService().navigateTo("/");
        return false;
      }
    }
  }

  void _setTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", accessToken);
    await prefs.setString("refreshToken", refreshToken);
    return;
  }

  Future<http.Response> methodGet(String path) async {
    try {
      final pref = await this.getToken();
      final token = "Bearer ${pref['a']}";
      final http.Response res =
          await http.get("${this.baseUrl}$path", headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      });
      print("${this.baseUrl}$path ${res.statusCode}");
      if (res.statusCode <= 400) {
        return res;
      }
      // if (res.statusCode == 401) {
      //   final resData = await this._updateToken();
      //   if (resData) {
      //     return this.methodGet(path);
      //   } else {
      //     throw res;
      //   }
      // }
      throw res;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> methodPost(String path, dynamic body) async {
    try {
      final pref = await this.getToken();
      final token = "Bearer ${pref['a']}";
      final res = await http.post(
        "${this.baseUrl}$path",
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: body,
      );
      String access = jsonDecode(res.body)["accessToken"];
      String refresh = jsonDecode(res.body)["refreshToken"];
      if (access != null) {
        this._setTokens(access, refresh);
      }
      // if (res.statusCode == 401) {
      //   return _updateToken().then((resData) {
      //     if (resData) {
      //       return this.methodPost(path, body);
      //     } else {
      //       throw res;
      //     }
      //   });
      // }
      if (res.statusCode <= 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future<http.Response> methodPut(String path, dynamic body) async {
    try {
      final pref = await this.getToken();
      final token = "Bearer ${pref['a']}";
      final res = await http.put(
        "${this.baseUrl}$path",
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: body,
      );
      String access = jsonDecode(res.body)["accessToken"];
      String refresh = jsonDecode(res.body)["refreshToken"];
      if (access != null) {
        this._setTokens(access, refresh);
      }
      // if (res.statusCode == 401) {
      //   return _updateToken().then((resData) {
      //     if (resData) {
      //       return this.methodPut(path, body);
      //     } else {
      //       throw res;
      //     }
      //   });
      // }
      if (res.statusCode <= 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future<http.Response> methodPatch(String path, dynamic body) async {
    try {
      final pref = await this.getToken();
      final token = "Bearer ${pref['a']}";
      final res = await http.patch(
        "${this.baseUrl}$path",
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: body,
      );
      String access = jsonDecode(res.body)["accessToken"];
      String refresh = jsonDecode(res.body)["refreshToken"];
      if (access != null) {
        this._setTokens(access, refresh);
      }
      // if (res.statusCode == 401) {
      //   return _updateToken().then((resData) {
      //     if (resData) {
      //       return this.methodPatch(path, body);
      //     } else {
      //       throw res;
      //     }
      //   });
      // }
      if (res.statusCode <= 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future<http.Response> methodDelete(String path) async {
    try {
      final pref = await this.getToken();
      final token = "Bearer ${pref['a']}";
      final res = await http.delete(
        "${this.baseUrl}$path",
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      String access = jsonDecode(res.body)["accessToken"];
      String refresh = jsonDecode(res.body)["refreshToken"];
      if (access != null) {
        this._setTokens(access, refresh);
      }
      // if (res.statusCode == 401) {
      //   return _updateToken().then((resData) {
      //     if (resData) {
      //       return this.methodDelete(path);
      //     } else {
      //       throw res;
      //     }
      //   });
      // }
      if (res.statusCode <= 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }
}
