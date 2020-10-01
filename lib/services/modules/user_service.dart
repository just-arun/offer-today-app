import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:offer_today/services/config/service_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final _apiService = HttpService();

  Future<http.Response> getProfile() async {
    try {
      final result = await this._apiService.methodGet("/user/profile");
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> updateMinilalProfile(String userID, dynamic data) async {
    try {
      final result = await this._apiService.methodPut("/user/$userID", data);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<http.Response> getAllUsers() async {
    try {
      final result = await this._apiService.methodGet("/user");
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> search(String key) async {
    try {
      final result =
          await this._apiService.methodGet("/user/search/user?key=$key");
      if (result.statusCode < 400) {
        final json = jsonDecode(result.body);
        final data = List<Map<String, dynamic>>.from(json["data"]);
        return data;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> posts(String userID, int page) async {
    try {
      final result =
          await this._apiService.methodGet("/user/$userID/posts?page=$page");
      if (result.statusCode < 400) {
        final json = jsonDecode(result.body);
        final data = List<Map<String, dynamic>>.from(json["data"]);
        return data;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> fav(String userID, int page) async {
    try {
      final result =
          await this._apiService.methodGet("/user/$userID/fav?page=$page");
      if (result.statusCode < 400) {
        final json = jsonDecode(result.body);
        final data = List<Map<String, dynamic>>.from(json["data"]);
        return data;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future getUser(String id) async {
    try {
      final result = await this._apiService.methodGet("/user/$id");
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<dynamic> create(dynamic inputData) async {
    try {
      final result = await this._apiService.methodPost(
            "/user",
            inputData,
          );
      print(result.statusCode);
      if (result.statusCode < 400) {
        // final json = jsonDecode(result.body)["data"];
        // final data = Map<String, dynamic>.from(json);
        return "data";
      }
      throw result;
    } on HttpException catch (err) {
      print(err.message);
      throw err;
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
