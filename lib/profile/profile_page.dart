import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/components/custom_button.dart';
import 'package:hive_firebase/components/custom_nav_bar.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_archive_cubit.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_cubit.dart';
import 'package:hive_firebase/profile/components/profile_menus.dart';
import 'package:hive_firebase/profile/components/toggle_sync_button.dart';
import 'package:hive_firebase/profile/components/user_details.dart';

import '../features/authentication/presentations/cubits/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final UserModel? currentUser;

  @override
  void initState() {
    if (authCubit.currentUser != null) {
      currentUser = authCubit.currentUser;
    }
    super.initState();
  }

  void logoutUser() {
    final notesCubit = context.read<NotesCubit>();
    final archiveCubit = context.read<NotesArchiveCubit>();
    final authCubit = context.read<AuthCubit>();
    notesCubit.noteBox.clear();
    archiveCubit.deletedNotesBox.clear();
    authCubit.logoutUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      UserDetails(currentUser: currentUser),

                      SizedBox(height: 32),

                      ProfileMenus(),

                      SizedBox(height: 8),

                      ToggleSyncButton(),

                      SizedBox(height: 120),
                      
                      CustomButton(text: 'Logout', function: logoutUser, width: double.infinity,)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              CustomNavBar(currentPage: 'profile'),
            ],
          ),
        ),
      ),
    );
  }
}
