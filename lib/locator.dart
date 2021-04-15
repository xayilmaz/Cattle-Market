
import 'package:come491_cattle_market/repository/user_repository.dart';
import 'package:come491_cattle_market/services/fake_auth_service.dart';
import 'package:come491_cattle_market/services/firebase_auth_service.dart';
import 'package:come491_cattle_market/services/firebase_storage_service.dart';
import 'package:come491_cattle_market/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;  // GetIt.I -  GetIt.instance - nin kisaltmasidir

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebbaseStorageService());
}
