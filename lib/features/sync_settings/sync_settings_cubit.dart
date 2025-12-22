import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';

class SyncSettingsCubit extends Cubit<SyncSettings> {
  final SyncDataSource syncDataSource;

  SyncSettingsCubit(this.syncDataSource)
      : super(syncDataSource.getCurrentSync());

  Future<void> toggleSync() async {
    await syncDataSource.toggleSync();
    emit(syncDataSource.getCurrentSync());
  }

  Future<void> enableSync() async {
    if (state.isSyncEnabled) return;
    await syncDataSource.setSync(true);
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
