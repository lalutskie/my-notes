
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';
import 'package:hive_firebase/features/notes/domain/repos/notes_repo.dart';

import '../../../sync_settings/sync_data_source.dart';

class NotesArchiveCubit extends Cubit<List<NotesModel>>{
  final Box<NotesModel> deletedNotesBox = Hive.box<NotesModel>('deletedNotes');
  final NotesRepo notesRepo; 
  final SyncDataSource syncDataSource;


  NotesArchiveCubit({required this.notesRepo, required this.syncDataSource}) : super([]);

  void loadDeletedNotes() {
    final notes = deletedNotesBox.values.toList();

    // ✅ Sort by deletedAt descending (newest first)
    notes.sort((a, b) {
      final aDate = a.deletedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.deletedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate); // Descending order
    });
    emit(deletedNotesBox.values.toList());
  }

  void restoreNote(NotesModel note) async {
    final notesBox = Hive.box<NotesModel>('notes');

    // Clear deletedAt before restoring locally
    final restoredNote = note.copyWith(deletedAt: null);
    await notesBox.put(restoredNote.id, restoredNote);

    final sync = syncDataSource.getCurrentSync();
    if (sync.isSyncEnabled) {
      await notesRepo.createNote(restoredNote);
    }

    // Just remove from local trash
    await deletedNotesBox.delete(note.id);

    loadDeletedNotes(); // Refresh UI
  }


  void permanentlyDelete(String noteId) async {
    await deletedNotesBox.delete(noteId);
    final sync = syncDataSource.getCurrentSync();
    if (sync.isSyncEnabled) {
      await notesRepo.deleteNote(noteId);
    }
    loadDeletedNotes();
  }
}