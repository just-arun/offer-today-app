import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/pages/post/comments/comments.dart';
import 'package:offer_today/pages/post/comments/comments_list.dart';
import 'package:offer_today/pages/post/comments/create_comment.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/widgets/popup_dialog/popup_dialog.dart';
import 'package:offer_today/widgets/users/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailPage extends StatefulWidget {
  final String id;
  PostDetailPage({@required this.id});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> with PostMixin {
  Map<String, dynamic> data = {
    "id": "",
    "likeCount": 0,
    "title": "",
    "imageUrl": "",
    "description": "",
  };
  String userID = "";
  int userType = 0;
  List<Map<String, dynamic>> _comments = [];

  void initFun() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final userID = pref.getString("uid");
      final uType = pref.getInt("userType");
      final post = await this.getOnePost(widget.id);
      final comments = await this.getComments(widget.id);
      print(comments);
      setState(() {
        data = post;
        this.userID = userID;
        this.userType = uType;
        _comments = comments;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    this.initFun();
  }

  @override
  Widget build(BuildContext context) {
    print("${data['imageUrl']}, ${data['likeCount']}, ${data['title']}");
    return Scaffold(
        appBar: AppBar(
          title: Text("${data['title']}"),
          actions: <Widget>[
            (userType == 2 || data["id"] == userID)
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {})
                : SizedBox(),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        minWidth: double.infinity, maxWidth: double.infinity),
                    child: data['imageUrl'] != ""
                        ? Image.network(
                            "${Config.baseUrl}/${data['imageUrl']}",
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.broken_image),
                              );
                            },
                          )
                        : SizedBox(
                            height: 20.0,
                          ),
                  ),
                  Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Post Description",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            "${data['description']}",
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      )),
                  CreateComment(id: widget.id),
                  Column(
                    children: _comments
                        .map(
                          (item) => Comments(item: item),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
