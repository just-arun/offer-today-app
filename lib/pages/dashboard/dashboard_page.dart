import 'package:flutter/material.dart';

import 'package:offer_today/pages/dashboard/manage-post/manage-post.dart';
import 'package:offer_today/pages/dashboard/user-tab/user-tab.dart';
import 'package:offer_today/pages/dashboard/user/create-user_page.dart';
import 'package:offer_today/pages/dashboard/user/search-user.dart';
import 'package:offer_today/util/rout-navigation.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _page = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    UserTabe(),
    ManagePost(),
    Text(
      'overall',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
  }

  Widget _addUserButton() {
    return _page == 0
        ? AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 60.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(SlideBottomRoute(page: CreateUserPage()));
              },
              child: Icon(Icons.add),
            ),
          )
        : SizedBox();
  }

  Widget _userSearchIcon() {
    return _page == 0
        ? IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearch());
            },
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: <Widget>[_userSearchIcon()],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_page),
      ),
      floatingActionButton: _addUserButton(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: Text("Users"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications),
              title: Text("Manage"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              title: Text("Data"),
            ),
          ]),
    );
  }
}

// class UserSearch extends SearchDelegate<String> {
//   final users = [
//     "one",
//     "two",
//     "three",
//     "one",
//     "two",
//     "three",
//     "one",
//     "two",
//     "three",
//     "one",
//     "two",
//     "three",
//   ];

//   final recentCities = [];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {}

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty ? recentCities : users;
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         leading: Icon(Icons.location_city),
//         title: Text(suggestionList[index]),
//       ),
//       itemCount: suggestionList.length,
//     );
//   }
// }
