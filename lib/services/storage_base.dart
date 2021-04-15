import 'dart:io';

import 'package:come491_cattle_market/model/user.dart';

abstract class StorageBase {
  Future<String> uploadFile(
    String userID,
    String fileType,
      File yuklenecekDosya,
  );
}
