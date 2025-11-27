import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:hive_firebase/components/custom_loading.dart";
import "package:hive_firebase/features/notes/domain/models/notes_model.dart";
import "package:hive_firebase/features/notes/presentations/cubits/notes_state.dart";

import "../components/custom_back_button.dart";
import "../components/custom_button.dart";
import "../components/custom_column_spacing.dart";
import "../components/custom_snackbar_service.dart";
import "../components/custom_textfield.dart";
import "../features/authentication/domain/models/user_model.dart";
import "../features/authentication/presentations/cubits/auth_cubit.dart";
import "../features/notes/presentations/cubits/notes_cubit.dart";
import "../utils/custom_theme.dart";

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  late final notesCubit = context.read<NotesCubit>();
  late final authCubit = context.read<AuthCubit>();

  late final UserModel? user;

  @override
  void initState() {
    user = authCubit.currentUser; 
    super.initState();
  }

  void createNote() async {
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

    await notesCubit.createNote(
      NotesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: user!.uid,
        title: _titleController.text,
        description: _descController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
  


  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(function: () => context.pop()),

                SizedBox(height: 16),

                Text(
                  'Add new notes here!',
                  style: CustomTheme.typography(context).headlineLarge,
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
                        ),

                        CustomTextfield(
                          minLines: 4,
                          maxLines: 8,
                          labelText: 'Description',
                          hintText: 'This is my main google account...',
                          controller: _descController,
                          obSecureText: false,
                        ),
                      ],
                    );
                  },
                ),

                Spacer(),

                BlocConsumer<NotesCubit, NotesState>(
                  builder: (context, state) {
                    

                    if(state is NotesUploading) {
                      return CustomLoading();
                    }

                    return CustomButton(
                      width: double.infinity,
                      backgroundColor: CustomTheme.colors(context).primary,
                      textColor: Colors.white,
                      text: 'Create note',
                      function: createNote
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
      ),
    );
  }
}
