import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:offer_today/services/modules/post_service.dart';
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

mixin PostMixin {
  Future<List<Map<dynamic, dynamic>>> getPosts(
      BuildContext context, int page, String tag) async {
    try {
      final data = await PostService().getPosts(page, tag);
      final json = jsonDecode(data.body)["data"];
      final List<Map<dynamic, dynamic>> response =
          new List<Map<dynamic, dynamic>>.from(json);
      return response;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future createPost(BuildContext context, String description, String imageUrl,
      String title, String tag) async {
    try {
      final data =
          await PostService().createPosts(description, imageUrl, title, tag);
      final json = jsonDecode(data.body)["data"];
      return json;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getTags(
    BuildContext context,
  ) async {
    try {
      final res = await PostService().getTags();
      final json = jsonDecode(res.body)["data"];
      final data = List<Map<String, dynamic>>.from(json);
      return data;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future createTag(BuildContext context, String name) async {
    try {
      final res = await PostService().createTags(name);
      final json = jsonDecode(res.body);
      return json;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future deleteTag(BuildContext context, String id) async {
    try {
      final res = await PostService().deleteTags(id);
      final json = jsonDecode(res.body);
      return json;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> searchPost(
      BuildContext context, String query) async {
    try {
      final res = await PostService().search(query);

      return res;
    } catch (err) {
      logoutRedirect(context, err);
      throw err;
    }
  }

  Future<Map<String, dynamic>> getOnePost(
      BuildContext context, String id) async {
    try {
      final res = await PostService().getOne(id);
      final json = jsonDecode(res.body);
      print(json);
      final data = Map<String, dynamic>.from(json["data"]);
      return data;
    } catch (err) {
      logoutRedirect(context, err);
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(
      BuildContext context, String id) async {
    try {
      final res = await PostService().getComments(id);
      final json = jsonDecode(res.body);
      final data = List<Map<String, dynamic>>.from(json["data"]);
      return data;
    } catch (err) {
      logoutRedirect(context, err);
      throw err;
    }
  }
}
