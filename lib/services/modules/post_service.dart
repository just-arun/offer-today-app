import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:offer_today/services/config/service_config.dart';

class PostService {
  final _apiService = HttpService();

  Future<http.Response> getPosts(int page, String tag) async {
    try {
      final result =
          await this._apiService.methodGet("/posts?page=$page&tag=$tag");
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> createPosts(
      String description, String imageUrl, String title, String tag) async {
    try {
      final result = await this._apiService.methodPost(
          "/posts",
          jsonEncode({
            "description": description,
            "imageUrl": imageUrl,
            "title": title,
            "tags": tag
          }));
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> getTags() async {
    try {
      final result = await this._apiService.methodGet("/posts/tag/get");
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<http.Response> createTags(String name) async {
    try {
      final result = await this
          ._apiService
          .methodPost("/posts/tag/create", json.encode({"name": name}));
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<http.Response> deleteTags(String id) async {
    try {
      final result =
          await this._apiService.methodDelete("/posts/tag/delete/$id");
      print(result.statusCode);
      if (result.statusCode < 400) {
        return result;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final result =
          await this._apiService.methodGet("/posts/search/post?key=$query");
      print(result.statusCode);
      if (result.statusCode < 400) {
        final json = jsonDecode(result.body)["data"];
        final data = List<Map<String, dynamic>>.from(json);
        return data;
      }
      throw result;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future getOne(String id) async {
    try {
      final res = await this._apiService.methodGet("/posts/$id");
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future getComments(String id) async {
    try {
      final res = await this._apiService.methodGet("/posts/$id/comments");
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future createComment(Map<String, String> comment) async {
    try {
      final res = await this._apiService.methodPost(
            "/comments",
            jsonEncode(comment),
          );
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future likUnlikePost(String id, bool like) async {
    try {
      final res = await this._apiService.methodPost(
          "/posts/$id/${like ? 'addlike' : 'removelike'}",
          jsonEncode({"data": 1}));
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }

  Future delete(String id) async {
    try {
      final res = await this._apiService
      .methodDelete("/posts/$id");
      if (res.statusCode < 400) {
        return res;
      }
      throw res;
    } catch (err) {
      throw err;
    }
  }
}
