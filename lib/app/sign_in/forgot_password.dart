import 'package:come491_cattle_market/app/hata_exception.dart';
import 'package:come491_cattle_market/app/sign_in/forgot_password_ok.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _formKey = GlobalKey<FormState>();
  String _email;

  String imageURL = 'assets/images/mail.png';

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image(
                  image: AssetImage(
                    imageURL,
                  ),
                  width: double.infinity,
                  height: 320,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: pColor,
                          fontSize: 30,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Please enter your email and we will send\n you a link return to your account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: pColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Muli'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        child: buildForgotPasswordTextField(),
                      ), //Email
                      SizedBox(
                        height: 10,
                      ), // Text
                      DefaultButton(
                          text: "Send Reset Link",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _formSubmit(context);
                            }
                          }),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  buildForgotPasswordTextField() {
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

  _formSubmit(BuildContext context) async {
    debugPrint(_email);
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      setState(() {
        imageURL = 'assets/images/success.png';
        print("Forgot Password Button");
        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => LoginSuccessScreen(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      PlatformDuyarliAlertDialog(
        "Sign In Error",
        Hatalar.goster(e.code),
        "Okey",
      ).goster(context);
    }
  }
}
