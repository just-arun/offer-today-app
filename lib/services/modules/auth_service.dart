import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:offer_today/services/config/service_config.dart';

class AuthService {
  final _apiService = HttpService();

  Future<http.Response> login(String email, String password) async {
    try {
      final result = await this._apiService.methodPost(
            "/auth/login",
            jsonEncode(
              {"email": email, "password": password},
            ),
          );
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> register(
      String userName, String email, String password) async {
    try {
      final result = await this._apiService.methodPost(
            "/auth/register",
            jsonEncode(
              {"userName": userName, "email": email, "password": password},
            ),
          );
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      throw e;
    }
  }
}
