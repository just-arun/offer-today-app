import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/mixins/auth_mixin.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/pages/post/search_post.dart';
import 'package:offer_today/pages/profile/profile.dart';
import 'package:offer_today/widgets/PostWidget/PostWidget.dart';
import 'package:offer_today/widgets/drawer/drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PostMixin, AuthMixin {
  bool _gridLayout = false;
  int _page = 1;
  List<Map<dynamic, dynamic>> _posts = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool viewer = true;
  int userType = 0;
  List<Map<String, dynamic>> _tagList = [];
  bool _filter = false;
  String _selectedTag = "";

  String _userName;
  String _imageUrl;
  String _uid;

  void _toggleLayout() {
    setState(() {
      if (_gridLayout) {
        _gridLayout = false;
      } else {
        _gridLayout = true;
      }
    });
  }

  void initFun() async {
    this._getTags();
    setState(() {
      _page = 1;
    });
    final res = await this.getPosts(this._page, this._selectedTag);
    setState(() {
      this._posts = res;
    });
    print("post length: ${res.length}");
    _refreshController.refreshCompleted();
  }

  void getUserPorfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final username = pref.getString("userName");
    final imageurl = pref.getString("imageUrl");
    final uid = pref.getString("uid");
    setState(() {
      this._userName = username;
      this._imageUrl = imageurl;
      this._uid = uid;
    });
  }

  void setUserType() async {
    // viewer only
    bool viewOnly = await this.viewOnlyUser();
    int type = await this.userStatus();
    setState(() {
      viewer = viewOnly;
      userType = type;
    });
  }

  void nextPage() async {
    await this.getPosts(this._page, this._selectedTag).then((res) {
      if (res.length < 1) {
        setState(() {
          _page = _page - 1;
        });
      }
      setState(() {
        this._posts.addAll(res);
      });
      _refreshController.loadComplete();
    });
  }

  void _onRefresh() async {
    setState(() {
      _page = 1;
    });
    await Future.delayed(Duration(milliseconds: 1000));
    print("page: $_page");
    this.initFun();
  }

  void _onLoading() async {
    setState(() {
      _page += 1;
    });
    print("page: $_page");
    await Future.delayed(Duration(milliseconds: 1000));
    this.nextPage();
  }

  List<DropdownMenuItem> buildDropdownMenuItems() {
    return [
      DropdownMenuItem(
          child: Row(
              children: <Widget>[Icon(Icons.account_circle), Text("Profile")]),
          onTap: () {}),
      DropdownMenuItem(
          child: Row(
              children: <Widget>[Icon(Icons.account_circle), Text("Logout")]),
          onTap: () {}),
    ];
  }

  void _logoutUser() {
    this.logout();
    Navigator.of(context).pushNamed("/");
  }

  void _profilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProfilePage(userID: _uid,))
    );
  }

  void _toggleFilterFun() {
    if (_filter) {
      setState(() {
        _filter = false;
        _selectedTag = "";
      });
      this.initFun();
    } else {
      setState(() {
        _filter = true;
      });
    }
  }

  Widget _filterListItems() {
    return _filter
        ? Container(
            color: Colors.white,
            height: 40.0,
            padding: EdgeInsets.all(2.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _tagList
                  .map((tag) => Container(
                        margin: EdgeInsets.all(3.0),
                        child: RawMaterialButton(
                          fillColor: _selectedTag == tag["id"]
                              ? Colors.deepPurple
                              : Colors.white,
                          splashColor: Colors.purple,
                          shape: const StadiumBorder(),
                          onPressed: () {
                            setState(() {
                              _selectedTag = tag["id"];
                            });
                            this.initFun();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 10.0,
                            ),
                            child: Text(
                              "#${tag['name']}",
                              style: GoogleFonts.poppins(
                                color: _selectedTag == tag["id"]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        : SizedBox();
  }

  Widget _moreMenu() {
    return PopupMenuButton<String>(
      onSelected: handleClick,
      itemBuilder: (BuildContext context) {
        return [
          {"text": "Toggle Layout", "icon": Icons.list, "onTap": "layout"},
          {"text": "Profile", "icon": Icons.account_circle, "onTap": "profile"},
          {"text": "Logout", "icon": Icons.exit_to_app, "onTap": "logout"},
        ].map((item) {
          return PopupMenuItem<String>(
            value: item["text"],
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                switch (item["onTap"]) {
                  case "logout":
                    this._logoutUser();
                    break;
                  case "profile":
                    this._profilePage();
                    break;
                  case "layout":
                    this._toggleLayout();
                    break;
                }
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    item["icon"],
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(item["text"])
                ],
              ),
            ),
          );
        }).toList();
      },
    );
  }

  Widget _filterPosts() {}

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  void _getTags() async {
    try {
      final data = await this.getTags();
      print(data);
      setState(() {
        _tagList = data as List<Map<String, dynamic>>;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    this.initFun();
    this.getUserPorfile();
  }

  @override
  Widget build(BuildContext context) {
    this.isUserLogedIn().then((logedIn) {
      if (!logedIn) {
        Navigator.of(context).pushNamed("/");
      } else {
        this.setUserType();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Offer Today"),
          automaticallyImplyLeading: userType != 2 ? false : true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: PostSearch());
                }),
            IconButton(
                icon: Icon(Icons.filter_list), onPressed: _toggleFilterFun),
            _moreMenu(),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: GridView.count(
                  crossAxisCount: _gridLayout ? 1 : 2,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 2.0 / 2.1,
                  children: _posts
                      .map((post) => PostWidget(
                            gridLayout: _gridLayout,
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
                            userId: this._uid,
                          ))
                      .toList()),
            ),
            _filterListItems(),
          ],
        ),
        drawer: DrawerWidget(
            uid: this._uid,
            imageUrl: this._imageUrl,
            userName: this._userName,
            userType: this.userType),
        floatingActionButton: !viewer
            ? FloatingActionButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed("/create-post"),
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
