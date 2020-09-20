import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              hintText: "$label",
              border: OutlineInputBorder()
            ),
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
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2045),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _savPublisher() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Publisher"),
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                _inputField(
                  label: "User Name",
                  controll: _userNameController,
                  validator: (val) {},
                ),
                _inputField(
                  label: "Email",
                  controll: _emailController,
                  validator: (val) {},
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
                  label: "Registration Date",
                  controll: registrationDateController,
                  validator: (val) {},
                ),
                _inputField(
                  label: "Registration Date",
                  controll: registrationDateController,
                  validator: (val) {},
                ),
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Select date',
                  ),
                  color: Colors.greenAccent,
                ),
                _inputField(
                  label: "Registration Date",
                  controll: registrationDateController,
                  validator: (val) {},
                ),
                _inputField(
                  label: "Registration Date",
                  controll: registrationDateController,
                  validator: (val) {},
                ),
                _inputField(
                  label: "Registration Date",
                  controll: registrationDateController,
                  validator: (val) {},
                ),
              ],
            ),
          ),
        ));
  }
}
