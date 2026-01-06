
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_firebase/components/custom_textfield.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_cubit.dart';

import '../features/authentication/presentations/cubits/auth_cubit.dart';
import '../features/note_categories/domain/model/note_categories_model.dart';

class NotesCategoryTextfield extends StatefulWidget {
  const NotesCategoryTextfield({super.key, this.noteCategoriesModel});

  final NoteCategoriesModel? noteCategoriesModel;

  @override
  State<NotesCategoryTextfield> createState() => _NotesCategoryTextfieldState();
}

class _NotesCategoryTextfieldState extends State<NotesCategoryTextfield> {

  late TextEditingController textController;
  late final noteCategoriesCubit = context.read<NoteCategoriesCubit>();
  late final authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.noteCategoriesModel?.name ?? '');
  }

  void _submitEdit() async {
    final String newLabelName = textController.text;

    if (authCubit.currentUser == null) {
      return;
    }

    await noteCategoriesCubit.updateNoteCategory(
      NoteCategoriesModel(
        id: widget.noteCategoriesModel!.id,
        uid: authCubit.currentUser!.uid,
        name: newLabelName,
        updatedAt: DateTime.now(),
        createdAt: widget.noteCategoriesModel!.createdAt,
        deletedAt: widget.noteCategoriesModel!.deletedAt,
        isDeleted: false
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return CustomTextfield(controller: textController, obSecureText: false, textInputAction: TextInputAction.done, onSubmit: () => _submitEdit(), );
  }
}