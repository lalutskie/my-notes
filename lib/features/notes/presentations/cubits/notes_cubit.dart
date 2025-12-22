import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_firebase/features/notes/domain/repos/notes_repo.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_state.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';
import '../../domain/models/notes_model.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepo notesRepo;
  final SyncDataSource syncDataSource;
  final noteBox = Hive.box<NotesModel>('notes');

  NotesCubit(this.syncDataSource, {required this.notesRepo})
    : super(NotesInitial());

  Future<void> getNoteList(String uid) async {
    emit(NotesLoading());
    try {
      final sync = syncDataSource.getCurrentSync();
      List<NotesModel> notes;

      if (sync.isSyncEnabled) {
        // ✅ Merge local and remote notes
        notes = await _mergeAndSync(uid);
      } else {
        notes = noteBox.values.toList();
      }

      _sortNotes(notes);

      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  // ✅ NEW: Merge local and remote notes when sync is enabled
  // ✅ Merge local and remote notes safely considering deletedNotes
  Future<List<NotesModel>> _mergeAndSync(String uid) async {
    final deletedNotesBox = Hive.box<NotesModel>('deletedNotes');
    final deletedIds = deletedNotesBox.keys.toSet();

    // Local notes excluding trash
    final localNotes = noteBox.values
        .where((note) => !deletedIds.contains(note.id))
        .toList();

    // Remote notes from Firebase
    final remoteNotes = await notesRepo.getNotes(uid);

    // Exclude remote notes that are in local trash
    final filteredRemoteNotes = remoteNotes
        .where((note) => !deletedIds.contains(note.id))
        .toList();

    // Map for easy lookup
    final remoteNotesMap = {
      for (var note in filteredRemoteNotes) note.id: note,
    };
    final mergedNotesMap = <String, NotesModel>{};
    mergedNotesMap.addAll(remoteNotesMap);

    final localOnlyNotes = <NotesModel>[];

    for (final localNote in localNotes) {
      if (remoteNotesMap.containsKey(localNote.id)) {
        final remoteNote = remoteNotesMap[localNote.id]!;
        if (localNote.updatedAt!.isAfter(remoteNote.updatedAt!)) {
          mergedNotesMap[localNote.id] = localNote;
          localOnlyNotes.add(localNote);
        }
      } else {
        mergedNotesMap[localNote.id] = localNote;
        localOnlyNotes.add(localNote);
      }
    }

    // Upload new or updated local notes
    for (final note in localOnlyNotes) {
      try {
        await notesRepo.createNote(note);
      } catch (_) {}
    }

    final mergedNotes = mergedNotesMap.values.toList();
    await _syncToLocal(mergedNotes);

    return mergedNotes;
  }

  // ✅ NEW: Method to handle sync toggle (call this when user enables sync)
  Future<void> enableSyncAndMerge(String uid) async {
    emit(NotesLoading());
    try {
      // Merge local and remote data
      final notes = await _mergeAndSync(uid);

      _sortNotes(notes);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> createNote(NotesModel newNote) async {
    emit(NotesUploading());

    try {
      final sync = syncDataSource.getCurrentSync();

      if (sync.isSyncEnabled) {
        await notesRepo.createNote(newNote);
      }

      // Always save locally
      await noteBox.put(newNote.id, newNote);

      final notes = noteBox.values.toList();
      _sortNotes(notes);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(NotesModel updatedNote) async {
    // ✅ Save the current notes BEFORE changing state
    final previousNotes = (state is NotesLoaded)
        ? List<NotesModel>.from((state as NotesLoaded).notesModel)
        : null;

    emit(NotesUploading());

    try {
      final sync = syncDataSource.getCurrentSync();

      if (sync.isSyncEnabled) {
        await notesRepo.updateNote(updatedNote);
      }

      await noteBox.put(updatedNote.id, updatedNote);

      // ✅ Use saved notes OR reload from Hive
      List<NotesModel> currentNotes;

      if (previousNotes != null) {
        // Smart update - use cached list
        currentNotes = previousNotes;
        final index = currentNotes.indexWhere((n) => n.id == updatedNote.id);

        if (index != -1) {
          currentNotes[index] = updatedNote;
        }
      } else {
        // Fallback - reload from Hive
        currentNotes = noteBox.values.toList();
      }

      _sortNotes(currentNotes);
      emit(NotesLoaded(currentNotes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> archivedNote(String id) async {
    emit(NotesUploading());
    try {
      final deletedBox = Hive.box<NotesModel>('deletedNotes');

      final noteToDelete = noteBox.get(id);

      if (noteToDelete == null) return;
      final updatedNote = noteToDelete.copyWith(deletedAt: DateTime.now());

      // ✅ Move to deletedNotes box
      await deletedBox.put(updatedNote.id, updatedNote);
      await noteBox.delete(id);

      // Update UI
      final updatedNotes = noteBox.values.toList();
      _sortNotes(updatedNotes);
      emit(NotesLoaded(updatedNotes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> bookmarkNote(String noteId, bool isBookmarked) async {
    try {
      final sync = syncDataSource.getCurrentSync();

      final note = noteBox.get(noteId);
      if (note != null) {
        final updateNote = note.copyWith(
          isBookmarked: isBookmarked,
        );

        await noteBox.put(noteId, updateNote);
      }

      if (sync.isSyncEnabled) {
        await notesRepo.bookmarkNote(noteId, isBookmarked);
      }

      final notes = noteBox.values.toList();

      _sortNotes(notes);

      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  // Helper method to sync data to local Hive
  Future<void> _syncToLocal(List<NotesModel> notes) async {
    await noteBox.clear();
    for (final note in notes) {
      await noteBox.put(note.id, note);
    }
  }

  // Helper method to sort notes by updatedAt
  void _sortNotes(List<NotesModel> notes) {
    notes.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
  }

  void filterByLabel(String? categoryId) {

    final currentNotes = noteBox.values.toList();
    _sortNotes(currentNotes);
    if(categoryId == null) {
      emit(NotesLoaded(currentNotes));
      return;
    } 

    final filteredNotes = currentNotes.where((note) => note.categoryId == categoryId).toList();

    emit(NotesLoaded(filteredNotes));
  }
}
