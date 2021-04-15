import 'package:come491_cattle_market/model/user.dart';
import 'package:flutter/material.dart';


abstract class AuthBase{
  Future<Kullanici> currentUser();
  Future<Kullanici> signInAnonymously();
  Future<bool> signOut();

  Future<Kullanici> signInWithGoogle();
  Future<Kullanici> createUserWithEmailandPassword(String email,String sifre);
  Future<Kullanici> signInWithEmailandPassword(String email,String sifre);

  

}