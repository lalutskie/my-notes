import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/authentication/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;
  final box = Hive.box<UserModel>('currentUser');

  @override
  Future<UserModel?> getCurrentuser() async {
    try {
      final firebaseUser = _fAuth.currentUser;

      if (firebaseUser != null) {
        final userSnapshot = await _fStore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data();
          final userModel = UserModel.fromMap(userData as Map<String, dynamic>);
          return userModel;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Cannot get user: $e');
    }
  }

  @override
  Future<UserModel?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _fAuth.signInWithEmailAndPassword(email: email, password: password);

      final user = await getCurrentuser();
      if (user != null) {
        await box.put('currentUser', user);
      }

      return user;
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  @override
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Creating auth registration
      UserCredential userCredential = await _fAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Creating user data

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _fStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      await box.put('currentUser', userModel);
      return userModel;
    } catch (e) {
      throw Exception('Error creating user auth: $e');
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      await _fAuth.signOut();
      box.delete('currentUser');
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }

  @override
  Future<void> updateCurrentUser(UserModel updateUser) async {
    try {
      await _fStore
          .collection('users')
          .doc(updateUser.uid)
          .update(updateUser.toMap());
      await box.put('currentUser', updateUser);
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }
}
