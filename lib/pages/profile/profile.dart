import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_today/mixins/auth_mixin.dart';
import 'package:offer_today/mixins/user_mixin.dart';
import 'package:offer_today/pages/post/post-detail.dart';
import 'package:offer_today/pages/profile/user-detail/user-detail.dart';
import 'package:offer_today/pages/profile/user-fav/user-fav.dart';
import 'package:offer_today/pages/profile/user-posts/user-posts.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/services/modules/image_upload_service.dart';
import 'package:offer_today/services/modules/user_service.dart';
import 'package:offer_today/widgets/users/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  ProfilePage({@required this.userID});
  @override
  _ProfilePageState createState() => _ProfilePageState(userID: this.userID);
}

class _ProfilePageState extends State<ProfilePage> with UserMixin, AuthMixin {
  int _page = 0;
  File _image;
  String _imagePath;
  bool viewer = true;
  int userType = 0;
  TextEditingController _descriptionController =
      new TextEditingController(text: "");

  TextEditingController _userNameController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _registrationNumberController =
      TextEditingController(text: "");
  TextEditingController _addressController = TextEditingController(text: "");
  TextEditingController _poBoxController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController faxController = TextEditingController(text: "");
  TextEditingController mobileController = TextEditingController(text: null);
  TextEditingController registrationDateController =
      TextEditingController(text: "");
  TextEditingController subscriptionController =
      TextEditingController(text: "");
  TextEditingController paymentTermsController =
      TextEditingController(text: "");
  TextEditingController contactPersonController =
      TextEditingController(text: "");
  TextEditingController contactPersonDescriptionController =
      TextEditingController(text: "");
  String _imageUrl;
  bool _editProfile = false;
  final userID;
  _ProfilePageState({@required this.userID});
  List<Widget> tabList = [];

  String getUserId() {
    return this.userID;
  }

  Future _getImage() async {
    var _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imagePath = pickedFile.path;
      final File file = File(pickedFile.path);
      print(file);
      setState(() {
        _image = file;
      });
      this._saveImage();
    }
  }

  Widget showImage() {
    return _image != null ? Image.file(_image) : SizedBox();
  }

  void _saveImage() async {
    await FileUpload().upload(_image).then((res) {
      print(res);
      setState(() {
        _imageUrl = res;
      });
    });
  }

  Widget _postImage() {
    return !(_imageUrl == null || _imageUrl == "")
        ? ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Container(
              constraints: BoxConstraints(minHeight: 120, minWidth: 120),
              child: Image.network(
                "${Config.baseUrl}/$_imageUrl",
                width: 120,
              ),
            ))
        : Text(this._avatarText(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 40.0,
                color: Colors.white));
  }

  Widget _inputField(String text, TextEditingController controll) {
    Widget input = _editProfile
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

  String _avatarText() {
    return _userNameController.text
        .split(" ")
        .map((e) => e[0].toUpperCase())
        .join();
  }

  void _savePorfile() async {
    print("save profile");
  }

  void setUserType() async {
    // viewer only
    bool viewOnly = await this.viewOnlyUser();
    int type = await this.userStatus();
    setState(() {
      viewer = viewOnly;
      userType = type;
    });
  }

  void initFun() async {
    setState(() {
      tabList.add(UserDetail(
        userID: this.userID,
      ));
      tabList.add(UserFav(
        this.userID,
      ));
      tabList.add(UserPosts(
        this.userID,
      ));
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
  }

  List<BottomNavigationBarItem> _postsTag() {
    return userType != 0
        ? [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: "Posts",
            ),
          ]
        : [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
          ];
  }

  @override
  void initState() {
    super.initState();
    this.initFun();
    this.setUserType();
    // this.isLogedin(context);
  }

  @override
  Widget build(BuildContext context) {
    // this.isLogedin(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: tabList[_page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: _postsTag(),
        ),
      ),
    );
  }
}
