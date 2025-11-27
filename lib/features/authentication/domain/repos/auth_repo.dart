import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel?> loginWithEmailAndPassword(String email, String password);

  Future<UserModel?> registerWithEmailAndPassword(String email, String password, String name);

  Future<void> logoutUser();

  Future<UserModel?> getCurrentuser();

  Future<void> updateCurrentUser(UserModel userModel);
}