import 'package:flutter/material.dart';
import 'package:offer_today/mixins/user_mixin.dart';
import 'package:offer_today/services/modules/user_service.dart';

class UserDetail extends StatefulWidget {
  final String userID;
  UserDetail({Key key, this.userID}) : super(key: key);
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with UserMixin {
  String id;
  String userName;
  String email;
  List posts = [];
  List comments = [];
  List likes = [];
  List bookmarks = [];
  String imageUrl;
  String registrationNumber;
  String address;
  String poBox;
  String phone;
  String fax;
  String mobile;
  String registrationDate;
  String subscription;
  String paymentTerms;
  String contactPerson;
  String contactPersonDescription;
  int userStatus;
  int userType;
  String cretedAt;
  String updatedAt;

  void initFun() async {
    try {
      final res = await UserService().getUser(widget.userID);
      print(res);
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
    return Container(
      child: Text(widget.userID),
    );
  }
}
