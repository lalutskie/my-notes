import 'package:hive_ce/hive.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';

class SyncDataSource {

  final syncBox = Hive.box<SyncSettings>('syncSettings');

  SyncSettings getCurrentSync() {
    return syncBox.get('syncSettings', defaultValue: SyncSettings(isSyncEnabled: false))!;
  }

  Future<void> saveSyncSetting(SyncSettings settings) async {
    await syncBox.put('syncSettings', settings);
  }

  Future<void> toggleSync() async {
    final current = getCurrentSync();
    final updated = SyncSettings(isSyncEnabled: !current.isSyncEnabled);
    await saveSyncSetting(updated);
  }
}