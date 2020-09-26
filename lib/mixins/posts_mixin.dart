import 'dart:convert';

import 'package:offer_today/services/modules/post_service.dart';

mixin PostMixin {
  Future<List<Map<dynamic, dynamic>>> getPosts(int page, String tag) async {
    try {
      final data = await PostService().getPosts(page, tag);
      final json = jsonDecode(data.body)["data"];
      final List<Map<dynamic, dynamic>> response =
          new List<Map<dynamic, dynamic>>.from(json);
      return response;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future createPost(
      String description, String imageUrl, String title, String tag) async {
    try {
      final data =
          await PostService().createPosts(description, imageUrl, title, tag);
      final json = jsonDecode(data.body)["data"];
      return json;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getTags() async {
    try {
      final res = await PostService().getTags();
      final json = jsonDecode(res.body)["data"];
      final data = List<Map<String, dynamic>>.from(json);
      return data;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future createTag(String name) async {
    try {
      final res = await PostService().createTags(name);
      final json = jsonDecode(res.body);
      return json;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future deleteTag(String id) async {
    try {
      final res = await PostService().deleteTags(id);
      final json = jsonDecode(res.body);
      return json;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> searchPost(String query) async {
    try {
      final res = await PostService().search(query);

      return res;
    } catch (err) {
      throw err;
    }
  }

  Future<Map<String, dynamic>> getOnePost(String id) async {
    try {
      final res = await PostService().getOne(id);
      final json = jsonDecode(res.body);
      print(json);
      final data = Map<String, dynamic>.from(json["data"]);
      return data;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String id) async {
    try {
      final res = await PostService().getComments(id);
      final json = jsonDecode(res.body);
      final data = List<Map<String, dynamic>>.from(json["data"]);
      return data;
    } catch(err) {
      throw err;
    }
  }

}
