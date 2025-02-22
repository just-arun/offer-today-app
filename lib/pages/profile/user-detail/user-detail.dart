import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/mixins/auth_mixin.dart';
import 'package:offer_today/mixins/user_mixin.dart';
import 'package:offer_today/services/modules/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetail extends StatefulWidget {
  final String userID;
  UserDetail({Key key, this.userID}) : super(key: key);
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with UserMixin, AuthMixin {
  final _formKey = GlobalKey<FormState>();
  bool _edit = false;
  int _currentUserType = 0;
  bool viewer = true;
  int userType = 0;

  TextEditingController _id = TextEditingController(text: "");
  TextEditingController _userName = TextEditingController(text: "");
  TextEditingController _email = TextEditingController(text: "");
  List _posts = [];
  List _comments = [];
  List _likes = [];
  List _bookmarks = [];
  TextEditingController _imageUrl = TextEditingController(text: "");
  TextEditingController _registrationNumber = TextEditingController(text: "");
  TextEditingController _address = TextEditingController(text: "");
  TextEditingController _poBox = TextEditingController(text: "");
  TextEditingController _phone = TextEditingController(text: "");
  TextEditingController _fax = TextEditingController(text: "");
  TextEditingController _mobile = TextEditingController(text: "");
  TextEditingController _registrationDate = TextEditingController(text: "");
  TextEditingController _subscription = TextEditingController(text: "");
  TextEditingController _paymentTerms = TextEditingController(text: "");
  TextEditingController _contactPerson = TextEditingController(text: "");
  TextEditingController _contactPersonDescription =
      TextEditingController(text: "");
  int _userStatus;
  bool activeStatus = false;
  int _userType;
  TextEditingController _cretedAt = TextEditingController(text: "");
  TextEditingController _updatedAt = TextEditingController(text: "");

  void initFun() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        _currentUserType = pref.getInt("userType");
      });
      final res = await this.getOneUser(context, widget.userID);
      final id = res["id"];
      final userName = res["userName"];
      final email = res["email"];
      final imageUrl = res["imageUrl"];
      final registrationNumber = res["registrationNumber"];
      final address = res["address"];
      final poBox = res["poBox"];
      final phone = res["phone"];
      final fax = res["fax"];
      final mobile = res["mobile"];
      final registrationDate = res["registrationDate"];
      final subscription = res["subscription"];
      final paymentTerms = res["paymentTerms"];
      final contactPerson = res["contactPerson"];
      final contactPersonDescription = res["contactPersonDescription"];
      final cretedAt = res["cretedAt"];
      final updatedAt = res["updatedAt"];
      print("[user status:] ${res['userStatus'] > 0}");
      if (res["userStatus"] > 0) {
        setState(() {
          activeStatus = true;
        });
      } else {
        setState(() {
          activeStatus = false;
        });
      }
      setState(() {
        _id = TextEditingController(text: id);
        _userName = TextEditingController(text: userName);
        _email = TextEditingController(text: email);
        _imageUrl = TextEditingController(text: imageUrl);
        _registrationNumber = TextEditingController(text: registrationNumber);
        _address = TextEditingController(text: address);
        _poBox = TextEditingController(text: poBox);
        _phone = TextEditingController(text: phone);
        _fax = TextEditingController(text: fax);
        _mobile = TextEditingController(text: mobile);
        _registrationDate = TextEditingController(text: registrationDate);
        _subscription = TextEditingController(text: subscription);
        _paymentTerms = TextEditingController(text: paymentTerms);
        _contactPerson = TextEditingController(text: contactPerson);
        _contactPersonDescription =
            TextEditingController(text: contactPersonDescription);
        _cretedAt = TextEditingController(text: cretedAt);
        _updatedAt = TextEditingController(text: updatedAt);
        _userStatus = res["userStatus"];
      });
    } catch (err) {
      print(err);
    }
  }

  void _savePorfile() async {
    try {
      Map<String, dynamic> data = {
        "userName": _userName.text,
        "email": _email.text,
        "imageUrl": _imageUrl.text,
        "registrationNumber": _registrationNumber.text,
        "address": _address.text,
        "poBox": _poBox.text,
        "phone": _phone.text,
        "fax": _fax.text,
        "mobile": _mobile.text,
        "registrationDate": _registrationDate.text,
        "contactPerson": _contactPerson.text,
        "contactPersonDescription": _contactPersonDescription.text,
        "userStatus": _userStatus,
      };
      final json = jsonEncode(data);
      print("[JSON DATA] $json");
      if (this._formKey.currentState.validate()) {
        final res = await this.updateProfile(context, widget.userID, json);
        print(res);
      }
    } catch (err) {
      print("[err] $err");
    }
  }

  Widget _editButton() {
    return _currentUserType == 2
        ? FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_edit) {
                  this._savePorfile();
                }
              });
              setState(() {
                _edit = !_edit;
              });
            },
            child: Icon(_edit ? Icons.save : Icons.edit),
          )
        : SizedBox();
  }

  void setUserType() async {
    // viewer only
    bool viewOnly = await this.viewOnlyUser(context);
    int type = await this.userStatus(context);
    setState(() {
      viewer = viewOnly;
      userType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    this.setUserType();
    this.initFun();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InputField(
                          label: "User Name",
                          controller: _userName,
                          edit: _edit,
                        ),
                        InputField(
                          label: "Email",
                          controller: _email,
                          edit: _edit,
                        ),
                        InputField(
                            label: "Registration Number",
                            controller: _registrationNumber,
                            edit: _edit),
                        InputField(
                            label: "Address",
                            controller: _address,
                            edit: _edit),
                        InputField(
                          label: "Po Box",
                          controller: _poBox,
                          edit: _edit,
                        ),
                        InputField(
                          label: "Phone",
                          controller: _phone,
                          edit: _edit,
                        ),
                        InputField(
                          label: "Fax",
                          controller: _fax,
                          edit: _edit,
                        ),
                        InputField(
                            label: "Mobile Number",
                            controller: _mobile,
                            edit: _edit),
                        InputField(
                            label: "Contact Person",
                            controller: _contactPerson,
                            edit: _edit),
                        InputField(
                            label: "Contact Person Detail",
                            controller: _contactPersonDescription,
                            edit: _edit),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Status Active:"),
                            Expanded(child: Container()),
                            Switch(
                                value: activeStatus,
                                onChanged: (val) {
                                  if (!_edit) {
                                    return;
                                  }
                                  activeStatus = val;
                                  if (val) {
                                    setState(() {
                                      _userStatus = 1;
                                    });
                                  } else {
                                    setState(() {
                                      _userStatus = 0;
                                    });
                                  }
                                })
                          ],
                        ),
                        SizedBox(
                          height: 100.0,
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(child: Container()),
            Row(
              children: <Widget>[
                Expanded(child: Container()),
                _editButton(),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        )
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool edit;
  const InputField(
      {@required this.label, @required this.controller, this.edit});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            "$label",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 23.0,
              color: Colors.grey,
            ),
          ),
        ),
        edit
            ? TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: "$label"),
              )
            : Text(controller.text),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
