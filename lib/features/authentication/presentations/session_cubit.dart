
import '../../note_categories/presentations/cubits/note_categories_cubit.dart';
import '../../notes/presentations/cubits/notes_archive_cubit.dart';
import '../../notes/presentations/cubits/notes_cubit.dart';
import 'cubits/auth_cubit.dart';

class SessionCubit {
  final AuthCubit authCubit;
  final NotesCubit notesCubit;
  final NotesArchiveCubit archiveCubit;
  final NoteCategoriesCubit categoriesCubit;

  SessionCubit({
    required this.authCubit,
    required this.notesCubit,
    required this.archiveCubit,
    required this.categoriesCubit,
  });

  Future<void> logout() async {
    // TO:DO 
    notesCubit.noteBox.clear();
    archiveCubit.deletedNotesBox.clear();
    categoriesCubit.noteCategoriesBox.clear();
    await authCubit.logoutUser();
    return;
  }
}