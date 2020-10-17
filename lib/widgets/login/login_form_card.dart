import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum LoginFormCardType {
  login,
  register,
  forgotPassword,
  updatePassword,
}

class LoginFormCard extends StatelessWidget {
  final LoginFormCardType type;
  final void Function(LoginFormCardType) updateType;
  final String userName;
  final String email;
  final String password;
  final String password1;
  final int otp;
  final Function(String name, String value) updateFormField;

  LoginFormCard({
    @required this.type,
    this.updateType,
    this.userName,
    this.email,
    this.password,
    this.password1,
    this.updateFormField,
    this.otp,
  });

  Widget _emailWidget() {
    if (type == LoginFormCardType.login ||
        type == LoginFormCardType.forgotPassword ||
        type == LoginFormCardType.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          ),
          Text(
            "Email",
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
          TextFormField(
            validator: (value) {
              final bool isValid = EmailValidator.validate(this.email.trim());
              if (value.isEmpty) {
                return 'Please enter email address';
              }
              if (!isValid) {
                return 'Email is not valid';
              }
              return null;
            },
            onChanged: (val) => this.updateFormField("email", val),
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _userName() {
    if (type == LoginFormCardType.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          ),
          Text(
            "User Name",
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
            onChanged: (val) => this.updateFormField("userName", val),
            decoration: InputDecoration(
              hintText: "User Name",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _passwordWidget() {
    if (type == LoginFormCardType.login ||
        type == LoginFormCardType.register ||
        type == LoginFormCardType.updatePassword) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          ),
          Text(
            "Password",
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
            onChanged: (val) => this.updateFormField("password", val),
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _password1Widget() {
    if (type == LoginFormCardType.updatePassword ||
        type == LoginFormCardType.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          ),
          Text(
            "Confirm Password",
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
              if (this.password != this.password1) {
                return "Password dose'nt match";
              }
              return null;
            },
            onChanged: (val) => this.updateFormField("password1", val),
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }


  Widget _otpWidget() {
    if (type == LoginFormCardType.updatePassword) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(20.0),
          ),
          Text(
            "OPT",
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(26),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter OTP';
              }
              return null;
            },
            onChanged: (val) => this.updateFormField("otp", val),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "OTP from email",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _forgotPassword() {
    switch (type) {
      case LoginFormCardType.login:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () => this.updateType(LoginFormCardType.forgotPassword),
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            )
          ],
        );
      case LoginFormCardType.forgotPassword:
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "one time password will be sent to your regestered email address",
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return SizedBox(
          height: 30.0,
        );
    }
  }

  String _title() {
    switch (type) {
      case LoginFormCardType.login:
        return "Sign In";
      case LoginFormCardType.register:
        return "Sign Up";
      case LoginFormCardType.forgotPassword:
        return "Forgot Password";
      case LoginFormCardType.updatePassword:
        return "Update Password";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: ScreenUtil().setHeight(500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 15.0),
            blurRadius: 15.0,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -10.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _title(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                letterSpacing: 0.6,
              ),
            ),
            _userName(),
            _emailWidget(),
            _otpWidget(),
            _passwordWidget(),
            _password1Widget(),
            _forgotPassword(),
          ],
        ),
      ),
    );
  }
}

class LoginFormSubmitButton extends StatelessWidget {
  final String text;
  final void Function() onTap;

  LoginFormSubmitButton({@required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(330),
        height: ScreenUtil().setWidth(100),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF17ead9),
                Color(0xFF6078ea),
              ],
            ),
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6078ea).withOpacity(.3),
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0,
              )
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                "$text",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
