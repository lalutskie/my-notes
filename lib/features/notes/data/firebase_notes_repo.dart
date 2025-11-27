import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';
import 'package:hive_firebase/features/notes/domain/repos/notes_repo.dart';

class FirebaseNotesRepo implements NotesRepo {
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;

  @override
  Future<void> createNote(NotesModel createNote) async {
    try {
      await _fStore
          .collection('notes')
          .doc(createNote.id)
          .set(createNote.toMap());
    } catch (e) {
      throw Exception('Error creating note: $e');
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await _fStore.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw Exception('Error deleting note: $e');
    }
  }

  @override
  Future<List<NotesModel>> getNotes(String userId) async {
    try {
      final noteSnapshot = await _fStore
          .collection('notes')
          .where('uid', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      final remoteNotes = noteSnapshot.docs
          .map((doc) => NotesModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // ✅ Return only remote notes — Hive caching handled in Cubit
      return remoteNotes;
    } catch (e) {
      throw Exception('Error getting notes: $e');
    }
  }

  @override
  Future<void> updateNote(NotesModel updateNote) async {
    try {
      final updatedData = NotesModel(
        id: updateNote.id,
        uid: updateNote.uid,
        title: updateNote.title,
        description: updateNote.description,
        updatedAt: DateTime.now(),
        createdAt: updateNote.createdAt,
      );

      await _fStore
          .collection('notes')
          .doc(updatedData.id)
          .update(updatedData.toMap());
    } catch (e) {
      throw Exception('Error updating notes: $e');
    }
  }
  
  @override
  Future<void> bookmarkNote(String noteId, bool isBookmarked) async {
    try {
      await _fStore.collection('notes').doc(noteId).update({
        'isBookmarked': isBookmarked,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error bookmarking note: $e');
    }
  }
}
