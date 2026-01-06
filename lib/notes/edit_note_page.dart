import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:hive_firebase/components/custom_loading.dart";
import "package:hive_firebase/features/notes/domain/models/notes_model.dart";
import "package:hive_firebase/features/notes/presentations/cubits/notes_state.dart";
import "package:hive_firebase/features/notes/presentations/cubits/notes_archive_cubit.dart";
import "package:hive_firebase/features/sync_settings/sync_settings_cubit.dart";

import "../components/custom_back_button.dart";
import "../components/custom_button.dart";
import "../components/custom_column_spacing.dart";
import "../components/custom_snackbar_service.dart";
import "../components/custom_textfield.dart";
import "../features/authentication/domain/models/user_model.dart";
import "../features/authentication/presentations/cubits/auth_cubit.dart";
import "../features/notes/presentations/cubits/notes_cubit.dart";
import "../utils/custom_theme.dart";
import "../utils/text_utils.dart";

class EditNotePage extends StatefulWidget {
  const EditNotePage({super.key, required this.note, this.isArchived});

  final NotesModel note;
  final bool? isArchived;

  @override
  State<EditNotePage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late final notesCubit = context.read<NotesCubit>();
  late final authCubit = context.read<AuthCubit>();
  late final syncCubit = context.read<SyncSettingsCubit>();
  late final notesArchiveCubit = context.read<NotesArchiveCubit>();

  late final UserModel? user;
  late final bool isArchived;
  late final bool isBookmarked;

  @override
  void initState() {
    user = authCubit.currentUser;
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
    isArchived = widget.isArchived ?? false;
    isBookmarked = widget.note.isBookmarked ?? false;
    super.initState();
  }

  void updateNote() async {
    if (user == null) {
      CustomSnackbarService.showError(context, 'No user to update');
      return;
    }

    String title = _titleController.text.trim();
    String description = _descController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      CustomSnackbarService.showError(context, "Can't create an empty note");
      return;
    }

    if (title == widget.note.title && description == widget.note.description) {
      return;
    }

    await notesCubit.updateNote(
      NotesModel(
        id: widget.note.id,
        uid: user!.uid,
        title: _titleController.text,
        description: _descController.text,
        createdAt: widget.note.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    if (mounted) {
      CustomSnackbarService.showSuccess(context, 'Updated successfully');
    }
  }

  void permanentlyDelete() {
    if(user == null) {
      return;
    }
    notesArchiveCubit.permanentlyDelete(widget.note.id);
    Future.delayed(const Duration(seconds: 1));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomBackButton(function: () => context.pop()),
                
                          SizedBox(width: 8),
                         
                        ],
                      ),
                    ),
                
                    PopupMenuButton(
                      tooltip: 'Menu',
                      elevation: 1,
                      color: Colors.white,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                onTap: () async {

                                  if(isArchived) {

                                    // Is archived = restore notes
                                    notesArchiveCubit.restoreNote(widget.note);
                                    await notesCubit.getNoteList(user!.uid);
                                  } else {
                                    // not archived = put to archive
                                  await notesCubit.archivedNote(widget.note.id);

                                  }
                                   
                                },
                                child: Text(
                                  isArchived ? 'Unarchive' : 'Archive',
                                  style: CustomTheme.typography(context)
                                      .bodyMedium
                                      .copyWith(
                                        color: CustomTheme.colors(
                                          context,
                                        ).primaryText,
                                      ),
                                ),
                              ),
                            
                
                        PopupMenuItem(
                          onTap: () async {
                           await notesCubit.bookmarkNote(widget.note.id, isBookmarked ? false : true);
                          },
                          child: Text(
                            isBookmarked ? 'Unfavorite' : 'Favorite',
                            style: CustomTheme.typography(context).bodyMedium
                                .copyWith(
                                  color: CustomTheme.colors(context).primaryText,
                                ),
                          ),
                        ),

                        PopupMenuItem(
                          onTap: () async {
                          },
                          child: Text(
                            'Label note',
                            style: CustomTheme.typography(context).bodyMedium
                                .copyWith(
                                  color: CustomTheme.colors(context).primaryText,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                
                      SizedBox(height: 16),
                
                      Text.rich(
                        TextSpan(
                          text: "Created at: ",
                          style: CustomTheme.typography(context).bodySmall.copyWith(
                            color: CustomTheme.colors(context).tertiaryText,
                          ),
                          children: [
                            TextSpan(
                              text: TextUtils.format(
                                date: widget.note.createdAt!,
                                format: "MMM d, yyyy - h:mma",
                              ),
                              style: CustomTheme.typography(context).bodySmall
                                  .copyWith(
                                    color: CustomTheme.colors(
                                      context,
                                    ).primary, // highlight color
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                
                      Text.rich(
                        TextSpan(
                          text: "Updated at: ",
                          style: CustomTheme.typography(context).bodySmall.copyWith(
                            color: CustomTheme.colors(context).tertiaryText,
                          ),
                          children: [
                            TextSpan(
                              text: TextUtils.format(
                                date: widget.note.updatedAt!,
                                format: "MMM d, yyyy - h:mma",
                              ),
                              style: CustomTheme.typography(context).bodySmall
                                  .copyWith(
                                    color: CustomTheme.colors(
                                      context,
                                    ).primary, // highlight color
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                
                      SizedBox(height: 16),
                
                      FormField(
                        builder: (context) {
                          return CustomColumnSpacing(
                            spacing: 8,
                            children: [
                              CustomTextfield(
                                hintText: 'Main Google Account...',
                                labelText: 'Title',
                                controller: _titleController,
                                obSecureText: false,
                                isReadable: isArchived,
                              ),
                
                              CustomTextfield(
                                minLines: 4,
                                maxLines: 8,
                                labelText: 'Description',
                                hintText: 'This is my main google account...',
                                controller: _descController,
                                obSecureText: false,
                                isReadable: isArchived,
                              ),
                            ],
                          );
                        },
                      ),
                
                      Spacer(),
                
                      BlocConsumer<NotesCubit, NotesState>(
                        builder: (context, state) {
                          if (state is NotesUploading) {
                            return CustomLoading();
                          }
                
                          return CustomButton(
                            width: double.infinity,
                            backgroundColor: isArchived
                                ? CustomTheme.colors(context).secondaryBackground
                                : CustomTheme.colors(context).primary,
                            textColor: isArchived
                                ? CustomTheme.colors(context).error
                                : CustomTheme.colors(context).secondaryText,
                            text: isArchived
                                ? 'Delete permanently'
                                : 'Update note',
                            function: isArchived ? permanentlyDelete : updateNote,
                            borderColor: isArchived
                                ? CustomTheme.colors(context).error
                                : null,
                          );
                        },
                        listener: (context, state) {
                          if (state is NotesError) {
                            return CustomSnackbarService.showError(
                              context,
                              state.errorMessage,
                            );
                          }
                
                          if (state is NotesLoaded) {
                            return context.pop();
                          }
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
