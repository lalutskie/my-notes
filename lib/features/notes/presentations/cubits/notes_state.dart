import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesUploading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NotesModel> notesModel;
  NotesLoaded(this.notesModel);
}

class NotesError extends NotesState {
  final String errorMessage;

  NotesError(this.errorMessage);
}

