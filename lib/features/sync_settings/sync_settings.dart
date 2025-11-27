import 'package:hive_ce/hive.dart';

part 'sync_settings.g.dart'; // this will be generated automatically

@HiveType(typeId: 2) // <-- must be unique across all Hive models
class SyncSettings extends HiveObject {
  @HiveField(0)
  final bool isSyncEnabled;

  SyncSettings({this.isSyncEnabled = false});
}
