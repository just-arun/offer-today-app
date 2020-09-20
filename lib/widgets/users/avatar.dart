import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/services/config/app_config.dart';

class UserAvatar extends StatelessWidget {
  final String id;
  final String userName;
  final String imageUrl;
  final double height;
  final double width;
  final bool showUserName;
  final FontWeight fontWeight;
  final double fontSize;

  UserAvatar({
    this.id,
    this.imageUrl,
    this.userName,
    this.height,
    this.width,
    this.showUserName,
    this.fontWeight,
    this.fontSize,
  });

  String _avatarName() {
    final name = this.userName != null
        ? this.userName.split(" ").map((e) => e[0]).join()
        : "";
    return name;
  }

  Widget _name() {
    return this.showUserName ? Text("$userName") : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Widget _avatarImage() {
      if (this.imageUrl != "" && this.imageUrl != null) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(
                this.height != null ? this.height : 300.0),
            child: Container(
              constraints: BoxConstraints(
                  minWidth: this.width != null ? this.width : 30.0,
                  minHeight: this.height != null ? this.height : 30.0),
              child: Image.network(
                "${Config.baseUrl}/$imageUrl",
                width: this.width != null ? this.width : 30.0,
                height: this.height != null ? this.height : 30.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ));
      } else {
        return Container(
          constraints: BoxConstraints(
            maxHeight: this.height != null ? this.height : 30.0,
            minHeight: this.height != null ? this.height : 30.0,
            maxWidth: this.width != null ? this.width : 30.0,
            minWidth: this.width != null ? this.width : 30.0,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  this.height != null ? this.height : 30.0),
              color: Colors.indigo),
          child: Center(
              child: Text(_avatarName(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                  ))),
        );
      }
    }

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          _avatarImage(),
          SizedBox(
            width: 10.0,
          ),
          _name(),
        ],
      ),
    );
  }
}
