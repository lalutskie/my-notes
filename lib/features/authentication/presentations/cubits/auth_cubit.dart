import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/authentication/domain/repos/auth_repo.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  UserModel? currentUser;

  AuthCubit({required this.authRepo, this.currentUser})
    : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {



      final remoteUser = await authRepo.getCurrentuser();

      if (remoteUser != null) {
        currentUser = remoteUser;
        emit(Authenticated(remoteUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.loginWithEmailAndPassword(email, password);
      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registeruser(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.registerWithEmailAndPassword(
        email,
        password,
        name,
      );

      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logoutUser() async {
    emit(AuthLoading());
    try {
      await authRepo.logoutUser();
      
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateCurrentUser(UserModel updateUser) async {
    emit(AuthLoading());
    try {
      await authRepo.updateCurrentUser(updateUser);
      emit(Authenticated(updateUser));
    } catch(e) {
      emit(AuthError(e.toString()));
    }
  }
}
