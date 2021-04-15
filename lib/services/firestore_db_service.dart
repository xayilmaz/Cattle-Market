import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/services/database_base.dart';
import 'package:flutter/material.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Kullanici user) async {
    await _firestoreDB.collection("users").doc(user.userID).set(user.toMap());

    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();

    Map _okunanUserBilgileriMapi = _okunanUser.data();
    Kullanici _okunanUserBilgileriNesne =
        Kullanici.fromMap(_okunanUserBilgileriMapi);
    print("okunan user nesnesi " + _okunanUserBilgileriNesne.toString());
    return true;
  }

  @override
  Future<Kullanici> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firestoreDB.collection("users").doc(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data();

    Kullanici _okunanUserNesnesi = Kullanici.fromMap(_okunanUserBilgileriMap);
    print("Okunan user nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firestoreDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'userName': yeniUserName});
      return true;
    }
  }

  updateProfilFoto(String userID, String profilFotoURL) async {
    await _firestoreDB
        .collection("users")
        .doc(userID)
        .update({'profilURL': profilFotoURL});
  }

  @override
  Future<bool> updatePhoneNumber(String userID, String yeniPhoneNumber) async {
    var users = await _firestoreDB
        .collection("users")
        .where("mobileNumber", isEqualTo: yeniPhoneNumber)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'mobileNumber': yeniPhoneNumber});
      return true;
    }
  }

  @override
  Future<bool> updateLocation(String userID, String yeniLocation) async {
    var users = await _firestoreDB
        .collection("users")
        .where("location", isEqualTo: yeniLocation)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'location': yeniLocation});
      return true;
    }
  }

  @override
  Future<bool> updateNameSurname(String userID, String yeniNameSurname) async {
    var users = await _firestoreDB
        .collection("users")
        .where("nameSurname", isEqualTo: yeniNameSurname)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'nameSurname': yeniNameSurname});
      return true;
    }
  }

  @override
  Future<bool> updateAbout(String userID, String yeniAbout) async {
    var users = await _firestoreDB
        .collection("users")
        .where("about", isEqualTo: yeniAbout)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'about': yeniAbout});
      return true;
    }
  }

  @override
  Future<List<Posts>> getAllPost() async {
    QuerySnapshot querySnapshot = await _firestoreDB.collection("posts").get();

    List<Posts> tumPosts = [];
    for(DocumentSnapshot tekUser in querySnapshot.docs){
      Posts _tekUser = Posts.fromMap(tekUser.data());
      tumPosts.add(_tekUser);
      print("Tek Post : " + tumPosts.toString());
    }
    return tumPosts;
  }

  @override
  Future<List<Kullanici>> getUser(String userID) async {

    DocumentSnapshot _okunanUser =
    await _firestoreDB.collection("users").doc(userID).get();

    List<Kullanici> userList = [];


    Kullanici _okunanUserNesnesi = Kullanici.fromMap(_okunanUser.data());
    print("Okunan user nesnesi //////////////: " + _okunanUserNesnesi.toString());
    userList.add(_okunanUserNesnesi);
    return userList;

  }

  @override
  Future<String> getUserName(String userID) async {
    DocumentSnapshot documentSnapshot1 = await _firestoreDB.collection("users").doc(userID).get();
    print("okunan user2----------------" + documentSnapshot1.data()['nameSurname']);

    String username = documentSnapshot1.data()['nameSurname'];
    print("----------------"+username);

    return username;
  }
  

}
