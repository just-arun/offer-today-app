import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/widgets/users/avatar.dart';


class UserBasicProfile extends StatelessWidget {
  final bool editProfile;
  final bool Function() toggleEditProfile;
  final void Function() saveProfile;
  final Function() getImage;
  final String imageUrl;
  final TextEditingController userName;
  final TextEditingController email;
  final Widget Function(String text, TextEditingController controll) inputField;

  UserBasicProfile({
    @required this.editProfile,
    @required this.toggleEditProfile,
    @required this.saveProfile,
    @required this.getImage,
    @required this.imageUrl,
    @required this.userName,
    @required this.email,
    @required this.inputField,
  });


  Widget _inputField(String text, TextEditingController controll) {
    Widget input = editProfile
        ? TextFormField(
            controller: controll,
            decoration: InputDecoration(
              hintText: text,
            ),
          )
        : Text(controll.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(text,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.grey)),
        input
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  IconButton(
                      icon: editProfile
                          ? Icon(Icons.save)
                          : Icon(Icons.mode_edit),
                      onPressed: () {
                        if (editProfile) {
                          this.saveProfile();
                        }
                        toggleEditProfile();
                      })
                ],
              ),
              Container(
                constraints: BoxConstraints(minHeight: 170.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: editProfile
                          ? () {
                              getImage();
                            }
                          : null,
                      child: UserAvatar(
                        imageUrl: this.imageUrl,
                        id: "",
                        height: 120.0,
                        width: 120.0,
                        userName: this.userName.text,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        showUserName: false,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _inputField("User Name", userName),
                      SizedBox(height: 20.0),
                      _inputField("Your Email", email),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}