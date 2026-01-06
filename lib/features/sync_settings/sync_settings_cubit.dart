import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_cubit.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';

import '../note_categories/presentations/cubits/note_categories_cubit.dart';
import '../notes/presentations/cubits/notes_cubit.dart';

class SyncSettingsCubit extends Cubit<SyncSettings> {
  final SyncDataSource syncDataSource;
  final NotesCubit notesCubit;
  final NoteCategoriesCubit noteCategoriesCubit;

  SyncSettingsCubit(this.syncDataSource, this.notesCubit, this.noteCategoriesCubit)
      : super(syncDataSource.getCurrentSync());

  Future<void> toggleSync() async {
    await syncDataSource.toggleSync();
    emit(syncDataSource.getCurrentSync());
  }

  Future<void> enableSync(String userId) async {
    if (state.isSyncEnabled) return;
    await syncDataSource.setSync(true);
    await notesCubit.enableSyncAndMerge(userId);
    await noteCategoriesCubit.enableSyncAndMerge(userId);
    emit(syncDataSource.getCurrentSync());
  }

  Future<void> disableSync() async {
    if (!state.isSyncEnabled) return;
    await syncDataSource.setSync(false);
    emit(syncDataSource.getCurrentSync());
  }

  /// Call this when app starts (optional)
  void refresh() {
    emit(syncDataSource.getCurrentSync());
  }
}
