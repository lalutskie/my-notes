import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_back_button.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/notes_list.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_cubit.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_state.dart';

import '../features/authentication/domain/models/user_model.dart';
import '../features/authentication/presentations/cubits/auth_cubit.dart';
import '../utils/custom_theme.dart';

class FavoriteNotesPage extends StatefulWidget {
  const FavoriteNotesPage({super.key});

  @override
  State<FavoriteNotesPage> createState() => _FavoriteNotesPageState();
}

class _FavoriteNotesPageState extends State<FavoriteNotesPage> {
  late final authCubit = context.read<AuthCubit>();
  late final notesCubit = context.read<NotesCubit>();
  late final UserModel? user;


  @override
  void initState() {
    if (authCubit.currentUser != null) {
      user = authCubit.currentUser;
      notesCubit.getNoteList(user!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                child: Row(
                  children: [

                    CustomBackButton(function: () => context.pop()),

                    SizedBox(width: 8,),
                    Text(
                      'Favorites',
                      style: CustomTheme.typography(context).headlineSmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 00, 16, 20),
                  child: Column(
                    children: [


                      BlocBuilder<NotesCubit, NotesState>(
                        builder: (context, state) {
                          if (state is NotesLoaded) {
                            final favoriteNotes = state.notesModel
                                .where((note) => note.isBookmarked == true)
                                .toList();
                            return Expanded(
                              child: NotesList(
                                notes: favoriteNotes,
                                emptyMessage:
                                    "Try to favorite one of your notes",
                                isListArchived: false,
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: CustomLoading(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
