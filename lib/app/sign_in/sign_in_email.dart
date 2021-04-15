import 'package:come491_cattle_market/app/hata_exception.dart';
import 'package:come491_cattle_market/app/sign_in/forgot_password.dart';
import 'package:come491_cattle_market/app/sign_in/sign_up_email.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailvePasswordLoginPage extends StatefulWidget {
  @override
  _EmailvePasswordLoginPageState createState() =>
      _EmailvePasswordLoginPageState();
}

class _EmailvePasswordLoginPageState extends State<EmailvePasswordLoginPage> {
  String _email, _sifre;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) async {
    _formKey.currentState.save();
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formType == FormType.LogIn) {
      try {
        Kullanici _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email, _sifre);
        if (_girisYapanUser != null) {
          debugPrint(
              "Oturum Açan User ID : " + _girisYapanUser.userID.toString());
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.code.toString());
        PlatformDuyarliAlertDialog(
          "Sign In Error",
          Hatalar.goster(e.code),
          "Okey",
        ).goster(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/cattle_logo.png',
                        ),
                        width: 130,
                        height: 130,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: pColor,
                          fontSize: 40,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Sign in with your email and password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: pColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Muli'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        child: buildSignInEmailTextField(),
                      ), //EmailText
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        child: buildSignInPasswordTextField(),
                      ), //PasswordText

                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              print("Forgot Password Button");
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    fontFamily: "Noto"),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      DefaultButton(
                          text: "Sign In",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formSubmit(context);
                            }
                          }),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account ? ",
                            style: TextStyle(fontSize: 18, fontFamily: "Muli"),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Email Giriş Button");
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              _formType == FormType.LogIn
                                  ? "Sign Up"
                                  : "Sign In",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Noto"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  buildSignInEmailTextField() {
    return TextFormField(
      onSaved: (String girilenEmail) {
        _email = girilenEmail;
      },
      keyboardType: TextInputType.emailAddress,
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return "\u26A0 Invalid email address.";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        labelText: "Email",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter your email",
        hintStyle: TextStyle(fontFamily: 'Muli', fontSize: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, right: 4, top: 20, bottom: 20),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            15,
            15,
            15,
          ),
          child: SvgPicture.asset(
            "assets/icons/Mail.svg",
            height: 24.0,
            width: 24.0,
          ),
        ),
      ),
    );
  }

  buildSignInPasswordTextField() {
    return TextFormField(
      onSaved: (String girilenSifre) {
        _sifre = girilenSifre;
      },
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        labelText: "Password",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter your password",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, right: 4, top: 20, bottom: 20),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            10,
            10,
            10,
          ),
          child: SvgPicture.asset(
            "assets/icons/Lock.svg",
            height: 14.0,
            width: 14.0,
          ),
        ),
      ),
    );
  }
}
