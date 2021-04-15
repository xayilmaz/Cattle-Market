import 'package:come491_cattle_market/app/home_page.dart';
import 'package:come491_cattle_market/app/sign_in/sign_in_page.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
