import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/pages/post/post-detail.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/util/rout-navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostWidget extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final dynamic owner;
  final int enquiryCount;
  final List<String> likes;
  final int likeCount;
  final int status;
  final String createdAt;
  final String updatedAt;
  final bool gridLayout;
  final String userId;

  bool _liked = false;
  bool _bookmarked = false;

  PostWidget(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.owner,
      this.enquiryCount,
      this.likes,
      this.likeCount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.gridLayout,
      this.userId});

  void _showMore(context) {
    print("title: $title, description: $description");
    Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              id: id,
            ),
          ),);
  }

  Widget _buttons({
    String name,
    IconData icon,
    bool activeConditionn,
    Function onTap,
    bool active,
  }) {
    return Expanded(
      child: Tooltip(
        message: "$name",
        child: Material(
          color: Colors.white,
          child: Container(
            height: gridLayout ? 50.0 : 35,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> likedCondition() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final bool like = pref.getStringList("_liked").contains(this.id);
    return like;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset(2.0, 2.0), blurRadius: 2.0)
      ]),
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              this._showMore(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.network(
                "${Config.baseUrl}/$imageUrl",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 7.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text(
                  "$title",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                constraints: BoxConstraints(maxWidth: double.infinity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buttons(
                        icon: Icons.favorite,
                        onTap: () {},
                        active: false,
                        name: "ADD TO FAVORITE"),
                    _buttons(
                        icon: Icons.remove_red_eye,
                        onTap: () => this._showMore(context),
                        active: false,
                        name: "POST DETAIL"),
                    _buttons(
                        icon: Icons.format_quote,
                        onTap: () {},
                        active: false,
                        name: "MAKE QUOTE"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
