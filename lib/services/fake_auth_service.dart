import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {

  String userID="123123123123123";

  @override
  Future<Kullanici> currentUser() async {
    return Kullanici(userID,"fakeuser");
  }

  @override
  Future<Kullanici> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),() => Kullanici(userID,"faceuser"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<Kullanici> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),() => Kullanici("google_user_id","fakeuser"));
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre) async {
    return await Future.delayed(Duration(seconds: 2),() => Kullanici("created_user_id","fakeuser"));
  }

  @override
  Future<Kullanici> signInWithEmailandPassword(String email, String sifre) async {
    return await Future.delayed(Duration(seconds: 2),() => Kullanici("sign_in_email_id","fakeuser"));
  }
}
