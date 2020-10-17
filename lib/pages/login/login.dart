import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:offer_today/mixins/auth_mixin.dart';
import 'package:offer_today/mixins/user_mixin.dart';
import 'package:offer_today/services/modules/auth_service.dart';
import 'package:offer_today/widgets/login/login_form_card.dart';
import 'package:offer_today/widgets/popup_dialog/popup_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with UserMixin, AuthMixin {
  LoginFormCardType _formType = LoginFormCardType.login;
  String userName;
  String email;
  String password;
  String password1;
  int otp;
  final _formControl = GlobalKey<FormState>();
  bool loading = false;

  void _updateFormType(LoginFormCardType para) {
    setState(() {
      _formType = para;
    });
  }

  String _buttonText() {
    switch (_formType) {
      case LoginFormCardType.forgotPassword:
        return "SEND OTP";
      case LoginFormCardType.login:
        return "SIGN IN";
      case LoginFormCardType.register:
        return "SIGN UP";
      case LoginFormCardType.updatePassword:
        return "UPDARE";
    }
  }

  void _submitHandle() async {
    if (_formControl.currentState.validate()) {
      setState(() {
        this.loading = true;
      });
      switch (_formType) {
        case LoginFormCardType.login:
          this.login(
            context,
            this.email,
            this.password,
          );
          break;
        case LoginFormCardType.register:
          this.registerUser(
            context,
            this.userName,
            this.email,
            this.password,
          );
          break;
        case LoginFormCardType.forgotPassword:
          this.forgotPassowrd();
          break;
        case LoginFormCardType.updatePassword:
          this.updatePassword();
          break;
      }
      setState(() {
        this.loading = false;
      });
    }
  }

  void forgotPassowrd() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("email", email);
      final res = await AuthService().forgotPassword(email);
      print(res);
      setState(() {
        _formType = LoginFormCardType.updatePassword;
      });
    } catch (err) {
      print(err);
    }
  }

  void updatePassword() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(
        "email",
        email,
      );
      final res = await AuthService().updatePassword(email, password, otp);
      print(res);
      setState(() {
        _formType = LoginFormCardType.login;
      });
    } catch (err) {
      setState(() {
        _formType = LoginFormCardType.login;
      });
      print(err);
    }
  }

  List<InlineSpan> _additinalText() {
    switch (_formType) {
      case LoginFormCardType.forgotPassword:
        return [
          TextSpan(text: "go back to "),
          TextSpan(text: "login", style: TextStyle(color: Colors.blue))
        ];
      case LoginFormCardType.login:
        return [
          TextSpan(text: "don't have a account? "),
          TextSpan(text: "signup", style: TextStyle(color: Colors.blue))
        ];
      case LoginFormCardType.register:
        return [
          TextSpan(text: "signin", style: TextStyle(color: Colors.blue)),
          TextSpan(text: " to office today"),
        ];
      case LoginFormCardType.updatePassword:
        return [];
    }
  }

  Widget _showLoading() {
    return loading
        ? AlertDialog(
            content: Text("please wait..."),
          )
        : SizedBox();
  }

  void _additinalTextAction() {
    switch (_formType) {
      case LoginFormCardType.forgotPassword:
        setState(() {
          _formType = LoginFormCardType.login;
        });
        break;
      case LoginFormCardType.login:
        setState(() {
          _formType = LoginFormCardType.register;
        });
        break;
      case LoginFormCardType.register:
        setState(() {
          _formType = LoginFormCardType.login;
        });
        break;
      case LoginFormCardType.updatePassword:
        break;
      default:
        break;
    }
  }

  void _updateFormField(String name, value) {
    switch (name) {
      case "userName":
        setState(() {
          userName = value;
        });
        return;
      case "email":
        setState(() {
          email = value;
        });
        return;
      case "password":
        setState(() {
          password = value;
        });
        return;
      case "password1":
        setState(() {
          password1 = value;
        });
        return;
      case "otp":
        setState(() {
          otp = value;
        });
        return;
    }
  }

  Widget _loadingDialog() {
    return loading ? PopupDialog(show: true, text: "loading...") : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: 750,
      height: 1334,
      allowFontScaling: true,
    );

    this.isUserLoggedin(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: OKToast(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/image_01.png"),
                ),
                Expanded(child: Container()),
                Image.asset("assets/image_02.png"),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset("assets/logo.png", width: 120.0),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(180)),
                    Form(
                      key: _formControl,
                      child: Column(
                        children: <Widget>[
                          LoginFormCard(
                            type: _formType,
                            updateType: _updateFormType,
                            email: this.email,
                            userName: this.userName,
                            password1: this.password1,
                            password: this.password,
                            otp: this.otp,
                            updateFormField: _updateFormField,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          LoginFormSubmitButton(
                            text: _buttonText(),
                            onTap: () {
                              _submitHandle();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _additinalTextAction(),
                          child: RichText(
                              text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                            children: _additinalText(),
                          )),
                        )
                      ],
                    ),
                    SizedBox(height: 250.0),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _showLoading(),
              ],
            ),
            _loadingDialog(),
          ],
        ),
      ),
    );
  }
}
