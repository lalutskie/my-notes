
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';

abstract class NotesRepo {
  Future<void> createNote(NotesModel createNote);

  Future<void> updateNote(NotesModel updateNote);

  Future<void> deleteNote(String noteId);

  Future<void> bookmarkNote(String noteId, bool isBookmarked);

  Future<List<NotesModel>> getNotes(String userId);


}