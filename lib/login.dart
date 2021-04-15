// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// FirebaseAuth _auth = FirebaseAuth.instance;
//
// class App extends StatelessWidget {
//   // Create the initialization Future outside of `build`:
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire:
//       future: _initialization,
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text("hata çıktı" + snapshot.error.toString()),
//             ),
//           );
//         }
//
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return LoginIslemleri();
//         }
//
//         // Otherwise, show something whilst waiting for initialization to complete
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class LoginIslemleri extends StatefulWidget {
//   @override
//   _LoginIslemleriState createState() => _LoginIslemleriState();
// }
//
// class _LoginIslemleriState extends State<LoginIslemleri> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _auth.authStateChanges().listen((User user) {
//       if (user == null) {
//         print('Kullanıcı oturumu kapattı veya yok');
//       } else {
//         if(user.emailVerified){
//           print('Kullanıcı oturum açtı ve maili onayladı !');
//         }
//         else{
//           print('Kullanıcı oturum açtı ve maili onaylı değil !');
//         }
//
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("Login İşlemleri")),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             RaisedButton(
//                 child: Text("Email/Sifre User Create"),
//                 color: Colors.redAccent,
//                 onPressed: _emailSifreKullaniciOlustur),
//             RaisedButton(
//                 child: Text("Email/Sifre User Login"),
//                 color: Colors.blue,
//                 onPressed: _emailSifreKullaniciGirisYap),
//             RaisedButton(
//                 child: Text("Şifremi Unuttum."),
//                 color: Colors.yellowAccent,
//                 onPressed: _resetPassWord),
//             RaisedButton(
//                 child: Text("Email Güncelle."),
//                 color: Colors.deepPurple,
//                 onPressed: _updateMail),
//             RaisedButton(
//                 child: Text("Şifremi Güncelle."),
//                 color: Colors.pinkAccent,
//                 onPressed: _updatePassword),
//             RaisedButton(
//                 child: Text("Sign with Google"),
//                 color: Colors.yellowAccent,
//                 onPressed: signInWithGoogle),
//             RaisedButton(
//                 child: Text("Log Out"),
//                 color: Colors.red,
//                 onPressed: _cikisYap)
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _emailSifreKullaniciOlustur() async {
//     String _email = "alperenylmaz611@gmail.com";
//     String _password = "password";
//
//     try {
//       UserCredential _credential = await _auth.createUserWithEmailAndPassword(
//           email: _email, password: _password);
//
//       var user = _auth.currentUser;
//
//
//       User _yeniUser = _credential.user;
//       await _yeniUser.sendEmailVerification();
//
//       if (_auth.currentUser != null) {
//         debugPrint("Size Bir Mail Attık Lütfen Onaylayın");
//         _auth.signOut();
//         debugPrint("Kullanıcıyı Listeden Attık");
//       }
//
//       debugPrint(_yeniUser.toString());
//     } catch (e) {
//       debugPrint("*************HATA******************");
//       debugPrint(e.toString());
//     }
//   }
//
//   void _emailSifreKullaniciGirisYap() async {
//     try {
//       String _email = "alperenylmaz61@gmail.com";
//       String _password = "password1";
//       if (_auth.currentUser == null) {
//         User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
//                 email: _email, password: _password))
//             .user;
//         if (_oturumAcanUser.emailVerified) {
//           debugPrint("Mailinizi onaylı Anasayfaya gidebilir");
//         } else {
//           debugPrint("Lütfen mailinizi onaylayıp tekrar giriş yapın");
//           _auth.signOut();
//         }
//       } else {
//         debugPrint("oturum açmış kullanıcı zaten var");
//       }
//     } catch (e) {
//       debugPrint("*************HATA******************");
//       debugPrint(e.toString());
//     }
//   }
//
//   void _cikisYap() async {
//     if (_auth.currentUser != null) {
//       await _auth.signOut();
//     } else {
//       debugPrint("Zaten oturum açmış bir kullanıcı yok");
//     }
//   }
//
//   void _resetPassWord() async {
//     String _email = "alperenylmaz61@gmail.com";
//
//     try {
//       await _auth.sendPasswordResetEmail(email: _email);
//     } catch (e) {
//       debugPrint("Şifre Resetlenirken hata oluştu");
//     }
//   }
//
//   void _updatePassword() async {
//     try {
//       await _auth.currentUser.updatePassword("password2");
//       debugPrint("şifre güncellendi");
//     } catch (e) {
//       try {
//         String email = 'alperenylmaz61@gmail.com';
//         String password = 'password2';
//
//         // Create a credential
//         EmailAuthCredential credential =
//             EmailAuthProvider.credential(email: email, password: password);
//
//         // Reauthenticate
//         await FirebaseAuth.instance.currentUser
//             .reauthenticateWithCredential(credential);
//         debugPrint("girilen eski bilgiler doğru");
//         await _auth.currentUser.updatePassword("password2");
//         debugPrint("auth yeniden sağlandı, şifre güncellendi");
//       } catch (e) {
//         debugPrint("hata çıktı $e");
//       }
//       debugPrint("şifre güncellenirken hata çıktı $e");
//     }
//   }
//
//   void _updateMail() async {
//     try {
//       await _auth.currentUser.updateEmail("alperenylmaz61@gmail.com");
//       debugPrint("Email Güncellendi");
//     } on FirebaseAuthException catch (e) {
//       try {
//         String email = 'alperenylmaz61@gmail.com';
//         String password = 'password2';
//
//         // Create a credential
//         EmailAuthCredential credential =
//             EmailAuthProvider.credential(email: email, password: password);
//
//         // Reauthenticate
//         await FirebaseAuth.instance.currentUser
//             .reauthenticateWithCredential(credential);
//         debugPrint("girilen eski bilgiler doğru");
//         await _auth.currentUser.updateEmail("alperenylmaz61@gmail.com");
//         debugPrint("auth yeniden sağlandı, şifre güncellendi");
//       } catch (e) {
//         debugPrint("hata çıktı $e");
//       }
//       debugPrint("Email güncellenirken hata çıktı $e");
//     }
//   }
//
//   Future<UserCredential> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//
//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//
//       // Create a new credential
//       final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       // Once signed in, return the UserCredential
//       return await _auth.signInWithCredential(credential);
//     } catch (e) {
//       debugPrint("Gmail girişi hata");
//     }
//   }
// }

