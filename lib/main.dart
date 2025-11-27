import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings.dart';
import 'firebase_options.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(SyncSettingsAdapter());

  // ✅ Reopen boxes fresh
  await Hive.openBox<UserModel>('currentUser');
  await Hive.openBox<NotesModel>('notes');
  await Hive.openBox<NotesModel>('deletedNotes');
  await Hive.openBox<SyncSettings>('syncSettings');

  runApp(MyApp());
}
