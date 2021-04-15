import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/model/user.dart';

abstract class DBBase{
  Future<bool> saveUser(Kullanici user);
  Future<Kullanici> readUser(String userID);
  Future<bool> updateUserName(String userID,String yeniUserName);
  Future<bool> updatePhoneNumber(String userID,String yeniPhoneNumber);
  Future<bool> updateLocation(String userID,String yeniLocation);
  Future<bool> updateNameSurname(String userID,String yeniNameSurname);
  Future<bool> updateAbout(String userID,String yeniAbout);
  Future<List<Posts>> getAllPost();

  Future<List<Kullanici>> getUser(String userID);
  Future<String> getUserName(String userID);


}