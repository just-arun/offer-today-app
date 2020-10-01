import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/pages/post/post-detail.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/services/modules/post_service.dart';
import 'package:offer_today/util/rout-navigation.dart';
import 'package:offer_today/util/statefull-wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostWidget extends StatefulWidget {
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

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _liked = false;

  bool _bookmarked = false;

  void _showMore(context) {
    print("title: ${widget.title}, description: ${widget.description}");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          id: widget.id,
        ),
      ),
    );
  }

  void _createEnquiry() async {
    try {
      final Email email = Email(
        body: 'Email body',
        subject: 'Email subject',
        recipients: ['arunberry47@gmail.com'],
        cc: ['arunberry47@gmail.com'],
        bcc: ['arunberry47@gmail.com'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (err) {
      print(err);
    }
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
            height: widget.gridLayout ? 50.0 : 35,
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
    final bool like = pref.getStringList("_liked").contains(this.widget.id);
    return like;
  }

  void _toggleLike(setState) async {
    try {
      print(this._liked);
      if (this._liked) {
        setState(() {
          this._liked = false;
        });
      } else {
        setState(() {
          this._liked = true;
        });
      }
      await PostService().likUnlikePost(widget.id, this._liked);
    } catch (err) {
      print(err);
    }
  }

  void _checkLiked() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final uid = pref.getString("uid");
      bool liked = this.widget.likes.contains(uid);
      setState(() {
        _liked = liked;
      });
    } catch (err) {
      throw err;
    }
  }

  @override
  void initState() {
    super.initState();
    this._checkLiked();
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
                "${Config.baseUrl}/${widget.imageUrl}",
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
                  "${widget.title}",
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
                        onTap: () => _toggleLike(setState),
                        active: _liked,
                        name: "ADD TO FAVORITE"),
                    _buttons(
                        icon: Icons.remove_red_eye,
                        onTap: () => this._showMore(context),
                        active: false,
                        name: "POST DETAIL"),
                    _buttons(
                        icon: Icons.format_quote,
                        onTap: _createEnquiry,
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
