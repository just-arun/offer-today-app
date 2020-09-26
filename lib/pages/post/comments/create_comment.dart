import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/widgets/users/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateComment extends StatefulWidget {
  final String id;
  CreateComment({@required this.id});

  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  Map<String, String> _user = {
    "userName": "",
    "imageUrl": null,
  };
  bool _createComment = false;

  void iniiFun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _user = {
        "userName": pref.getString("userName"),
        "imageUrl": pref.getString("imageUrl")
      };
    });
  }

  Widget _commentInput() {
    return !_createComment
        ? Expanded(
            child: Container(
            margin: EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    this._createComment = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Enter your comment",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ))
        : SizedBox();
    // : Expanded(
    //     child: Container(
    //     child: Column(
    //       children: <Widget>[
    //         Container(
    //           constraints: BoxConstraints(
    //             maxWidth: double.infinity,
    //           ),
    //           margin: EdgeInsets.only(right: 20.0),
    //           child: TextField(
    //             maxLines: 5,
    //             decoration: InputDecoration(
    //                 border: OutlineInputBorder(),
    //                 hintMaxLines: 200,
    //                 hintText: "Your Comment"),
    //           ),
    //         ),
    //         Row(
    //           children: <Widget>[
    //             SizedBox(),
    //             RawMaterialButton(
    //               onPressed: () {
    //                 setState(() {
    //                   _createComment = false;
    //                 });
    //               },
    //               child: Text("CANCLE"),
    //             ),
    //             RaisedButton(
    //               onPressed: () {},
    //               child: Text("SEND"),
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   ));
  }

  @override
  void initState() {
    super.initState();
    this.iniiFun();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
            child: Text(
              "Comments",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserAvatar(
                id: "",
                width: 40,
                height: 40,
                imageUrl: _user["imageUrl"],
                userName: _user["userName"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                showUserName: false,
              ),
              _commentInput(),
            ],
          ),
        ],
      ),
    );
  }
}
