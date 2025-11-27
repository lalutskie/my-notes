
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';

class SyncSettingsCubit extends Cubit<SyncSettings> {
  final SyncDataSource syncDataSource;

  SyncSettingsCubit(this.syncDataSource)
    : super(syncDataSource.getCurrentSync());

  void toggleSync() async {
    await syncDataSource.toggleSync();
    emit(syncDataSource.getCurrentSync());
  }
}
