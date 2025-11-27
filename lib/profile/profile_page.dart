import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/components/custom_button.dart';
import 'package:hive_firebase/components/custom_menu_button.dart';
import 'package:hive_firebase/components/custom_nav_bar.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_archive_cubit.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_cubit.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings_cubit.dart';
import 'package:hive_firebase/utils/custom_theme.dart';
import 'package:hive_firebase/utils/text_utils.dart';

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
                      Text(
                        TextUtils.capitalizeEachWord(
                          currentUser?.name ?? 'Name name',
                        ),
                        style: CustomTheme.typography(context).headlineSmall
                            .copyWith(
                              color: CustomTheme.colors(context).primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      Text(
                        currentUser?.email ?? 'Your email',
                        style: CustomTheme.typography(context).bodyMedium
                            .copyWith(
                              color: CustomTheme.colors(context).tertiaryText,
                            ),
                      ),

                      SizedBox(height: 32),


                      CustomMenuButton(
                        function: () {},
                        leadIcon: Icons.edit_outlined,
                        trailIcon: Icons.chevron_right_rounded,
                        name: 'Update Profile',
                      ),

                      SizedBox(height: 8),

                      CustomMenuButton(
                        function: () {},
                        leadIcon: Icons.settings_outlined,
                        trailIcon: Icons.chevron_right_rounded,
                        name: 'Settings',
                      ),

                      SizedBox(height: 8),


                      BlocBuilder<SyncSettingsCubit, SyncSettings>(
                        builder: (context, state) {
                          return Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: CustomTheme.colors(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 16),
                                Icon(Icons.sync_outlined),
                                SizedBox(width: 8),

                                Text(
                                  state.isSyncEnabled ? 'Synced' : 'Not sync',
                                  style: CustomTheme.typography(context)
                                      .bodyMedium
                                      .copyWith(
                                        color: CustomTheme.colors(
                                          context,
                                        ).tertiaryText,
                                      ),
                                ),

                                Spacer(),
                                Switch(
                                  value: state.isSyncEnabled,
                                  focusColor: CustomTheme.colors(context).primary,
                                  activeThumbColor:  CustomTheme.colors(context).secondaryBackground,
                                  activeTrackColor:  CustomTheme.colors(context).primary,
                                  onChanged: (value) async {
                                    context
                                        .read<SyncSettingsCubit>()
                                        .toggleSync();

                                    print('sync settings: $value');

                                    if(value) {
                                      if (currentUser == null) return;

                                      await context
                                          .read<NotesCubit>()
                                          .enableSyncAndMerge(currentUser!.uid);
                                    }
                                  },
                                ),

                                SizedBox(width: 8),
                              ],
                            ),
                          );
                        },
                      ),

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
