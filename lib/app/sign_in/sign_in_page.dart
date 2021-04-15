import 'package:come491_cattle_market/app/sign_in/sign_in_email.dart';
import 'package:come491_cattle_market/app/sign_in/sign_up_email.dart';
import 'package:come491_cattle_market/common_widget/social_log_in_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void _emailVeSifreGiris(BuildContext context) {
    print("Sign In Button");
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailvePasswordLoginPage(),
      ),
    );
  }

  void _signUp(BuildContext context) {
    print("Sign Up Button");
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => SignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 40,
            ),
            Image(
              image: AssetImage(
                'assets/images/cattle_logo.png',
              ),
              width: 150,
              height: 150,
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                "Cattle Market",
                style: TextStyle(
                  fontFamily: 'Muli',
                  color: Colors.grey[850],
                  fontSize: 40,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Center(
                child: Text(
              "Reliable For Everyone",
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[800],
                  fontFamily: 'Muli'),
            )),
            SizedBox(
              height: 80,
            ),
            SocialLoginButton(
              yukseklik: 65,
              butonText: "Sign In",
              radius: 28,
              textColor: Colors.white,
              butonColor: kLogoColor,
              onPressed: () => _emailVeSifreGiris(context),
              butonIcon: Icon(
                Icons.login,
                size: 32,
                color: Colors.white,
              ),
            ),
            SocialLoginButton(
              yukseklik: 65,
              butonText: "Sign Up",
              radius: 28,
              textColor: Colors.white,
              butonColor: kLogoColor,
              onPressed: () => _signUp(context),
              butonIcon: Icon(
                Icons.person_add_outlined,
                size: 32,
                color: Colors.white,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
