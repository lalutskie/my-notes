import 'package:hive_ce/hive.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';

class SyncDataSource {
  final Box<SyncSettings> syncBox = Hive.box<SyncSettings>('syncSettings');

  static const _key = 'syncSettings';

  SyncSettings getCurrentSync() {
    return syncBox.get(
      _key,
      defaultValue: SyncSettings(isSyncEnabled: false),
    )!;
  }

  Future<void> saveSyncSetting(SyncSettings settings) async {
    await syncBox.put(_key, settings);
  }

  Future<void> toggleSync() async {
    final current = getCurrentSync();
    await setSync(!current.isSyncEnabled);
  }

  Future<void> setSync(bool enabled) async {
    final updated = SyncSettings(isSyncEnabled: enabled);
    await saveSyncSetting(updated);
  }
}
