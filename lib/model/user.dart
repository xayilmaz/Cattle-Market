import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Kullanici {
  final String userID;
  String email;
  String userName;
  String nameSurname;
  String mobileNumber;
  String profilURL;
  String location;
  String about;
  DateTime createdAt;
  DateTime updatedAt;
  var rank;

  Kullanici(@required this.userID, @required this.email);

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email ?? '',
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'mobileNumber': mobileNumber ?? "",
      'location' : location,
      'about' : about ?? "",
      'nameSurname': nameSurname ?? "",
      'profilURL': profilURL ?? 'https://devtalk.blender.org/uploads/default/original/2X/c/cbd0b1a6345a44b58dda0f6a355eb39ce4e8a56a.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updateAt': updatedAt ?? FieldValue.serverTimestamp(),
      'rank': rank ?? 4
    };
  }

  Kullanici.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        mobileNumber = map['mobileNumber'],
        location = map['location'],
        about = map['about'],
        nameSurname = map['nameSurname'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updateAt'] as Timestamp).toDate(),
        rank = map['rank'];

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }

  @override
  String toString() {
    return 'Kullanici{userID: $userID, email: $email, userName: $userName, nameSurname: $nameSurname, mobileNumber: $mobileNumber, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $rank}';
  }
}
