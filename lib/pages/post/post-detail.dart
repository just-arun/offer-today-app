import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/widgets/popup_dialog/popup_dialog.dart';

// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
class PostDetailValue {
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
  PostDetailValue(
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
}

class PostDetailPage extends StatelessWidget {
  static const routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    PostDetailValue args = ModalRoute.of(context).settings.arguments;
    print("${args.imageUrl}, ${args.likeCount}, ${args.title}");
    return Scaffold(
        appBar: AppBar(
          title: Text("${args.title}"),
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
                    child: Image.network(
                      "${Config.baseUrl}/${args.imageUrl}",
                      fit: BoxFit.fitWidth,
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
                            "${args.description}",
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}
