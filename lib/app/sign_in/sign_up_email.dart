import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/app/hata_exception.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
enum FormType { Register, LogIn }

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email, _sifre, _namesurname, _location, _phoneNumber, _about;
  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) async {
    _formKey.currentState.save();
    debugPrint("Email : $_email Password: $_sifre");
    final _userModel = Provider.of<UserModel>(context, listen: false);
    try {
      Kullanici _olusturulanUser =
          await _userModel.createUserWithEmailandPassword(_email, _sifre);
      _firestore.collection("users").doc(_olusturulanUser.userID).set({
        'nameSurname': _namesurname,
        'email': _email,
        'mobileNumber': _phoneNumber,
        'location': _location,
        'about': _about,
        'profilURL':
            'https://w7.pngwing.com/pngs/522/396/png-transparent-computer-icons-profile-miscellaneous-logo-profile.png',
        'createdAt': FieldValue.serverTimestamp(),
        'updateAt': FieldValue.serverTimestamp(),
        'userID': _olusturulanUser.userID,
      }).then((v) => debugPrint("Ekleme Başarılı"));

      if (_olusturulanUser != null) {
        debugPrint(
            "Oturum Açan User ID : " + _olusturulanUser.userID.toString());
      } else {
        debugPrint("Oturum Açılamadı !! ");
      }
    } on FirebaseAuthException catch (e) {
      PlatformDuyarliAlertDialog(
        "Login Error",
        Hatalar.goster(e.code),
        "Tamam",
      ).goster(context);
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
        title: Text("Sign Up"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          color: pColor,
                          fontSize: 40,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 76, right: 76, top: 2, bottom: 2),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Text(
                          "Please enter all requested\ninformation to register.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: pColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Muli'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 76, right: 76, top: 6, bottom: 20),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ),
                      buildNameSurnameTextField(),
                      //EmailText
                      SizedBox(
                        height: 10,
                      ),

                      buildSignInEmailTextField(),
                      //EmailText
                      SizedBox(
                        height: 10,
                      ),

                      buildSignInPasswordTextField(),
                      SizedBox(
                        height: 10,
                      ),
                      buildPhoneNumberTextField(),
                      SizedBox(
                        height: 10,
                      ),
                      buildLocationTextField(),
                      SizedBox(
                        height: 10,
                      ),
                      buildAboutTextField(),
                      //PasswordText
                      SizedBox(
                        height: 10,
                      ),
                      DefaultButton(
                          text: "Sign Up",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formSubmit(context);
                            }
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 20,
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

  buildNameSurnameTextField() {
    return TextFormField(
      onSaved: (String girilenNameSurname) {
        _namesurname = girilenNameSurname;
      },
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
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
            borderSide: BorderSide(color: Colors.redAccent),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Name & Surname",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter name & surname",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
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
          child: Icon(
            Icons.person_outline,
            size: 36,
          ),
        ),
      ),
    );
  } //NAME SURNAME BUTTON

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
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Email",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter your email",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
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
          child: Icon(
            Icons.mail_outline,
            size: 36,
          ),
        ),
      ),
    );
  } //EMAIL BUTTON

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
        } else if (value.length < 4) {
          return "\u26A0 Password is too weak.";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Password",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter your password",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
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
          child: Icon(
            Icons.lock_outline_rounded,
            size: 36,
          ),
        ),
      ),
    );
  } //PASSWORD BUTTON

  buildPhoneNumberTextField() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      onSaved: (String girilenPhoneNumber) {
        _phoneNumber = girilenPhoneNumber;
      },
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
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
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Phone",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter phone number",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
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
          child: Icon(
            Icons.phone,
            size: 36,
          ),
        ),
      ),
    );
  } //PHONE BUTTON

  buildLocationTextField() {
    return TextFormField(
      onSaved: (String girilenLocation) {
        _location = girilenLocation;
      },
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
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
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        labelText: "Location",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter location",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
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
          child: Icon(
            Icons.location_on_outlined,
            size: 36,
          ),
        ),
      ),
    );
  } //LOCATION BUTTON

  buildAboutTextField() {
    return TextFormField(
      onSaved: (String girilenAbout) {
        _about = girilenAbout;
      },
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      cursorColor: pColor,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "About",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter information\nabout you",
        hintStyle: TextStyle(
            color: Colors.grey[700], fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(15)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            10,
            10,
            10,
          ),
          child: Icon(
            Icons.text_fields,
            size: 36,
          ),
        ),
      ),
    );
  }
}
