import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_today/services/modules/user_service.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
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
  bool _status = true;
  int _userStatus = 1;
  final _formKey = GlobalKey<FormState>();

  Widget _inputField(
      {String label,
      TextEditingController controll,
      String Function(String) validator}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            controller: controll,
            validator: validator,
            decoration: InputDecoration(
                hintText: "$label", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _savPublisher() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final _today =
        new DateTime.now().toLocal().toUtc().toString().replaceAll(' ', "T");

    print("[today]: $_today");

    Map<String, dynamic> newData = {
      "userName": this._userNameController.text,
      "email": this._emailController.text,
      "password": "offer123",
      "registrationNumber": this._registrationNumberController.text,
      "address": this._addressController.text,
      "poBox": this._poBoxController.text,
      "phone": this.phoneController.text,
      "fax": this.faxController.text,
      "mobile": this.mobileController.text,
      "registrationDate": _today,
      "contactPerson": this.contactPersonController.text,
      "contactPersonDescription": this.contactPersonDescriptionController.text,
      "userStatus": this._userStatus,
      "userType": 1,
      "Expire": selectedDate.toUtc().toString().replaceAll(' ', 'T')
    };
    final json = jsonEncode(newData);
    print(json);

    print(newData);

    try {
      await UserService().create(json);
      Navigator.of(context).pop();
    } catch (err) {
      print("[err]: $err");
    }
  }

  void initFun() async {
    print(selectedDate.toIso8601String());
  }

  @override
  void initState() {
    super.initState();
    this.initFun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Publisher"),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => _savPublisher(),
              child: Row(
                children: <Widget>[
                  Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _inputField(
                    label: "User Name",
                    controll: _userNameController,
                    validator: (val) {
                      if (val.length < 1) {
                        return "User Name is required";
                      }
                      return null;
                    },
                  ),
                  _inputField(
                    label: "Email",
                    controll: _emailController,
                    validator: (val) {
                      final bool isValid = EmailValidator.validate(
                          this._emailController.text.trim());
                      if (val.isEmpty) {
                        return 'Please enter email address';
                      }
                      if (!isValid) {
                        return 'Email is not valid';
                      }
                      return null;
                    },
                  ),
                  _inputField(
                    label: "Regester Number",
                    controll: _registrationNumberController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Address",
                    controll: _addressController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "PO Box",
                    controll: _poBoxController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Phone Number",
                    controll: phoneController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Fax Number",
                    controll: faxController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Mobile Number",
                    controll: mobileController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Contact Person",
                    controll: contactPersonController,
                    validator: (val) {},
                  ),
                  _inputField(
                    label: "Contact Person Detail",
                    controll: contactPersonDescriptionController,
                    validator: (val) {},
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 15.0)
                        ]),
                    child: Material(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            "Expires In: " +
                                "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Active"),
                      Expanded(child: Container()),
                      Switch(
                          value: _status,
                          onChanged: (val) {
                            if (val) {
                              setState(() {
                                _status = val;
                                _userStatus = 1;
                              });
                            } else {
                              setState(() {
                                _status = val;
                                _userStatus = 0;
                              });
                            }
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
