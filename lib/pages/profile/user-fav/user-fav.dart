import 'package:flutter/material.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/services/modules/user_service.dart';
import 'package:offer_today/widgets/PostWidget/PostWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserFav extends StatefulWidget {
  final String userID;
  const UserFav(this.userID);
  @override
  _UserFavState createState() => _UserFavState();
}

class _UserFavState extends State<UserFav> {
  List<Map<String, dynamic>> _posts = [];
  int _page = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initFun() async {
    try {
      final posts = await UserService().fav(widget.userID, _page);
      setState(() {
        _posts = posts;
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

  void _onLoading() async {
    setState(() {
      _page += 1;
    });
    final posts = await UserService().fav(widget.userID, _page);
    posts.forEach((ele) {
      setState(() {
        _posts.add(ele);
      });
    });
    setState(() {
      _refreshController.loadComplete();
    });
  }

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
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 2.0 / 2.1,
        children: _posts
            .map(
              (post) => PostWidget(
                gridLayout: true,
                createdAt: post["createdAt"],
                enquiryCount: post["enquiryCount"],
                description: post["description"],
                id: post["id"],
                imageUrl: post["imageUrl"],
                likeCount: post["likeCount"],
                likes: List<String>.from(post["likes"]),
                owner: post["owner"],
                status: post["status"],
                title: post["title"],
                updatedAt: post["updatedAt"],
                userId: widget.userID,
              ),
            )
            .toList(),
      ),
    );
  }
}
