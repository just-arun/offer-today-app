import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offer_today/pages/dashboard/user/create-user_page.dart';
import 'package:offer_today/pages/dashboard/dashboard_page.dart';
import 'package:offer_today/pages/home/home.dart';
import 'package:offer_today/pages/login/login.dart';
import 'package:offer_today/pages/post/creat-post.dart';
import 'package:offer_today/pages/profile/profile.dart';
import 'package:offer_today/themes/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeData>(builder: (_, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: LoginPage(),
            routes: <String, WidgetBuilder>{
              "/home": (BuildContext context) => HomePage(),
              "/profile": (BuildContext context) => ProfilePage(),
              "/create-post": (BuildContext context) => CreatePost(),
              "/dashboard": (BuildContext context) => DashboardPage(),
              "/create-user": (BuildContext context) => CreateUserPage(),
            },
          );
        }));
  }
}
