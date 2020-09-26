import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/pages/profile/profile.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/widgets/users/avatar.dart';

class UserListTile extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String userName;
  final String email;
  final String phoneNumber;
  UserListTile(
      {this.userName,
      this.email,
      this.phoneNumber,
      this.imageUrl,
      this.userId});
  @override
  Widget build(BuildContext context) {
    print("[user ID]: $userId");
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userID: userId,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  userID: userId,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                    ),
                    child: UserAvatar(
                        imageUrl: this.imageUrl,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        height: 40.0,
                        width: 40.0,
                        id: "",
                        showUserName: false,
                        userName: this.userName),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$userName",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        "$email",
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
