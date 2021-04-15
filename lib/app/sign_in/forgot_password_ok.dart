import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Success"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10),
              Image.asset(
                "assets/images/success.png",
                height: 400, //40%
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Success",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pColor,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "Password reset link has been\n  sent to your email. Please check.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: pColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Muli'),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DefaultButton(
                    text: "Back to Sign In Page",
                    press: () {
                      print("Forgot Password Button");
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
