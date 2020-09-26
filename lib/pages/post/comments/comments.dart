import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/widgets/users/avatar.dart';

class Comments extends StatelessWidget {
  final Map<String, dynamic> item;
  const Comments({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserAvatar(
                id: "",
                width: 40,
                height: 40,
                imageUrl: item["owner"]["imageUrl"],
                userName: item["owner"]["userName"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                showUserName: false,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item["owner"]["userName"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(item["comment"])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
