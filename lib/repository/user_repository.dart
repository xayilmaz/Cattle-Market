import 'dart:io';

import 'package:come491_cattle_market/locator.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/services/auth_base.dart';
import 'package:come491_cattle_market/services/fake_auth_service.dart';
import 'package:come491_cattle_market/services/firebase_auth_service.dart';
import 'package:come491_cattle_market/services/firebase_storage_service.dart';
import 'package:come491_cattle_market/services/firestore_db_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakefirebaseAuthService =
      locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebbaseStorageService _firestoreStorageService = locator<FirebbaseStorageService>();


  AppMode appMode = AppMode.RELEASE;

  @override
  Future<Kullanici> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.currentUser();
    } else {
      Kullanici _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  @override
  Future<Kullanici> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<Kullanici> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.signInWithGoogle();
    } else {
      Kullanici _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      Kullanici _user = await _firebaseAuthService
          .createUserWithEmailandPassword(email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<Kullanici> signInWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakefirebaseAuthService.signInWithEmailandPassword(
          email, sifre);
    } else {
      Kullanici _user =
          await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {

      return await _firestoreDBService.updateUserName(userID,yeniUserName);
    }
  }

  updatePhoneNumber(String userID, String yeniPhoneNumber) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {

      return await _firestoreDBService.updatePhoneNumber(userID,yeniPhoneNumber);
    }
  }

  updateLocation(String userID, String yeniLocation) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {

      return await _firestoreDBService.updateLocation(userID,yeniLocation);
    }
  }

  uploadFile(String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
          var profilPhotoUrl = await _firestoreStorageService.uploadFile(userID, fileType, profilFoto);
          await _firestoreDBService.updateProfilFoto(userID,profilPhotoUrl);

      return profilPhotoUrl;
    }
  }

  updateNameSurname(String userID, String yeniNameSurname) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {

      return await _firestoreDBService.updateNameSurname(userID,yeniNameSurname);
    }
  }

  updateAbout(String userID, String yeniAbout) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {

      return await _firestoreDBService.updateAbout(userID,yeniAbout);
    }
  }

  getAllPost() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var tumPostsListesi = await _firestoreDBService.getAllPost();
      return tumPostsListesi;
    }
  }

  getUser(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var getUser = await _firestoreDBService.getUser(userID);
      return getUser;
    }
  }

  getUserName(userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var getUsername = await _firestoreDBService.getUserName(userID);
      return getUsername;
    }
  }



}
