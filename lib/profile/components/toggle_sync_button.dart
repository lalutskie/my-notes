import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_cubit.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_cubit.dart';

import '../../features/notes/presentations/cubits/notes_cubit.dart';
import '../../features/sync_settings/sync_settings.dart';
import '../../features/sync_settings/sync_settings_cubit.dart';
import '../../utils/custom_theme.dart';

class ToggleSyncButton extends StatelessWidget {
  const ToggleSyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncSettingsCubit, SyncSettings>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: CustomTheme.colors(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.sync_outlined),
              SizedBox(width: 8),

              Text(
                state.isSyncEnabled ? 'Synced' : 'Not sync',
                style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: CustomTheme.colors(context).tertiaryText,
                ),
              ),

              Spacer(),
              Switch(
                value: state.isSyncEnabled,
                focusColor: CustomTheme.colors(context).primary,
                activeThumbColor: CustomTheme.colors(
                  context,
                ).secondaryBackground,
                activeTrackColor: CustomTheme.colors(context).primary,
                onChanged: (value) async {
                  final authCubit = context.read<AuthCubit>();

                  if(authCubit.currentUser == null) return;

                  final syncCubit = context.read<SyncSettingsCubit>();

                  if(value) {
                    final String userId = authCubit.currentUser!.uid;
                    await syncCubit.enableSync(userId);
                    
                  } else {
                    await syncCubit.disableSync();
                  }


                },
              ),

              SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
