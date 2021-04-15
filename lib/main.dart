import 'package:come491_cattle_market/app/landing_page.dart';
import 'package:come491_cattle_market/locator.dart';
import 'package:come491_cattle_market/theme.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: LandingPage(),
      ),
    );
  }
}
