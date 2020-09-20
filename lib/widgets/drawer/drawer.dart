import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/pages/profile/profile.dart';
import 'package:offer_today/themes/themes.dart';
import 'package:offer_today/widgets/login/login_form_card.dart';
import 'package:offer_today/widgets/users/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String uid;
  final int userType;
  String _profileUserID;

  DrawerWidget({
    this.userName,
    this.imageUrl,
    this.uid,
    this.userType,
  });

  List<Map<String, dynamic>> _listTile = [
    {"text": "Profile", "path": "/profile", "icon": Icons.account_circle},
    {"text": "Dashboard", "path": "/dashboard", "icon": Icons.dashboard},
  ];

  void _route(BuildContext context, String path) {
    Navigator.of(context).popAndPushNamed(path);
  }

  void _getUserId() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = pref.getString("uid");
      this._profileUserID = uid;
    } catch (err) {
      print(err);
    }
  }

  List<Map<String, dynamic>> _routLinkList() {
    List<Map<String, dynamic>> list = [];
    for (var i = 0; i < _listTile.length; i++) {
      if (_listTile[i]["path"] == "/dashboard") {
        if (this.userType != 2) {
          break;
        }
      }
      list.add(_listTile[i]);
    }
    return list;
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).popAndPushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    _getUserId();
    return BlocBuilder<ThemeCubit, ThemeData>(builder: (_, theme) {
      return Drawer(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 180.0,
                  ),
                  Column(children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text("Profile"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              userID: _profileUserID,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text("Dashboard"),
                      onTap: () => _route(context, "/dashboard"),
                    ),
                  ]),
                  ListTile(
                    title: Text("Toggle Theme"),
                    leading: Icon(Icons.wb_sunny),
                    onTap: () => context.bloc<ThemeCubit>().toggleTheme(),
                  ),
                  SizedBox(
                    height: 180.0,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                LoginFormSubmitButton(
                  text: "LOGOUT",
                  onTap: () {
                    print(theme);
                    this._logout(context);
                    // context.bloc<ThemeCubit>().toggleTheme();
                  },
                ),
                SizedBox(
                  height: 15.0,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  constraints:
                      BoxConstraints(maxHeight: 180.0, minHeight: 180.0),
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(0, 133, 255, 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          UserAvatar(
                            height: 80.0,
                            width: 80.0,
                            id: this.uid,
                            imageUrl: this.imageUrl,
                            userName: this.userName,
                            showUserName: false,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "$userName",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // RaisedButton(
                //     onPressed: () {
                //       context.bloc<ThemeCubit>().toggleTheme();
                //     },
                //     child: Text("theme")),
                Expanded(child: Container())
              ],
            )
          ],
        ),
      );
    });
  }
}
