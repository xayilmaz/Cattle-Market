import 'dart:io';

import 'package:come491_cattle_market/services/storage_base.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirebbaseStorageService implements StorageBase{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;


  @override
  Future<String> uploadFile(String userID, String fileType, File yuklenecekDosya) async {
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType).child("profil_pfoto.png");
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }
}