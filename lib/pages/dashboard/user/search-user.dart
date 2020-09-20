import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/services/modules/user_service.dart';
import 'package:offer_today/widgets/users/list-tile.dart';

class UserSearch extends SearchDelegate<String> with PostMixin {
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
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestionList = query.isEmpty ? recentCities : users;
    return FutureBuilder(
        future: UserService().search(query),
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
                      (item) => UserListTile(
                        imageUrl: item["imageUrl"],
                        email: item["email"],
                        phoneNumber: item["phone"],
                        userName: item["userName"],
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
    // ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     leading: Icon(Icons.location_city),
    //     title: Text(suggestionList[index]),
    //   ),
    //   itemCount: suggestionList.length,
    // );
  }
}
