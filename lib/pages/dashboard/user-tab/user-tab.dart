import 'package:flutter/material.dart';
import 'package:offer_today/mixins/user_mixin.dart';
import 'package:offer_today/widgets/users/list-tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserTabe extends StatefulWidget {
  @override
  _UserTabeState createState() => _UserTabeState();
}

class _UserTabeState extends State<UserTabe> with UserMixin {
  List<Map<String, dynamic>> users = [];
  int _page = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initFun() async {
    try {
      final user = await this.getAllUsers(context);
      setState(() {
        users = user;
      });
    } catch (err) {
      print(err);
    }
  }

  void _onRefresh() async {
    setState(() {
      _page = 1;
    });
    this.initFun();
    this.setState(() {
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {}

  @override
  void initState() {
    super.initState();
    this.initFun();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropMaterialHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
          children: users
              .map((item) => UserListTile(
                    userId: item["id"],
                    userName: item["userName"],
                    email: item["email"],
                    phoneNumber: item["phone"],
                    imageUrl: item["imageUrl"],
                  ))
              .toList()),
    );
  }
}
