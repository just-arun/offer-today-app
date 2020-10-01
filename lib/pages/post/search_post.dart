import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/pages/post/post-detail.dart';
import 'package:offer_today/services/modules/post_service.dart';

class PostSearch extends SearchDelegate<String> with PostMixin {
  final List<Map<String, dynamic>> _postList = [];

  final recentCities = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("data"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: PostService().search(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final sErr = snapshot.error;
              final err = jsonDecode(sErr)["error"]["message"];
              return Center(
                child: Center(
                  child: Text(
                    "[ERROR]:$err",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              final List data = snapshot.data;
              print(data);
              return ListView(
                children: data
                    .map(
                      (item) => ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                id: item["id"],
                              ),
                            ),
                          );
                        },
                        title: Text("${item['title']}"),
                      ),
                    )
                    .toList(),
              );
            }
          }
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 14.0,
                ),
                Text("loading...")
              ],
            ),
          );
        });
  }
}
