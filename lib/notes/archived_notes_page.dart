
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_back_button.dart';
import 'package:hive_firebase/components/notes_list.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_archive_cubit.dart';

import '../features/notes/domain/models/notes_model.dart';
import '../utils/custom_theme.dart';

class ArchivedNotesPage extends StatefulWidget {
  const ArchivedNotesPage({super.key});

  @override
  State<ArchivedNotesPage> createState() => _ArchiveNotesState();
}

class _ArchiveNotesState extends State<ArchivedNotesPage> {


  @override
  void initState() {
    context.read<NotesArchiveCubit>().loadDeletedNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [

                Row(
                  children: [
                    CustomBackButton(function: context.pop,),
                    SizedBox(width: 8,),
                    Text(
                      'Archives',
                      style: CustomTheme.typography(context).headlineSmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                SizedBox(height: 16,),

                

                BlocBuilder<NotesArchiveCubit, List<NotesModel>>(
                  builder: (context, notes) {
                    return Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "(${notes.isNotEmpty ? notes.length : 0})",
                              style: CustomTheme.typography(context).bodyMedium
                                  .copyWith(
                                    color: CustomTheme.colors(
                                      context,
                                    ).tertiaryText,
                                  ),
                            ),
                          ),

                          SizedBox(height: 5,),
                          Expanded(
                            child: NotesList(
                              notes: notes,
                              emptyMessage: "You can see here you archived notes",
                              isListArchived: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}