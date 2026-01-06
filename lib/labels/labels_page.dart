import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_back_button.dart';
import 'package:hive_firebase/components/custom_floating_button.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/custom_snackbar_service.dart';
import 'package:hive_firebase/components/notes_category_item.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_cubit.dart';
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_cubit.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_state.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';

import '../features/notes/presentations/cubits/notes_cubit.dart';
import '../utils/custom_theme.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key, this.notesModel});

  final NotesModel? notesModel;

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  final Set<String> _selectedIds = {};
  late final noteCategoriesCubit = context.read<NoteCategoriesCubit>();
  late final authCubit = context.read<AuthCubit>();
  late final notesCubit = context.read<NotesCubit>();
  late bool? isAddLabelToNote;

  @override
  void initState() {
    super.initState();
    isAddLabelToNote = widget.notesModel != null;

    if(widget.notesModel?.categoryId != null) {
      _selectedIds.addAll(widget.notesModel!.categoryId!);
    }
  }

  void _toggleSelection(String id) async {
    setState(()  {
      if(_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });

    if (isAddLabelToNote == true && widget.notesModel != null) {
        await notesCubit.updateNote(
          NotesModel(
            id: widget.notesModel?.id ?? '',
            uid: widget.notesModel?.uid ?? '',
            title: widget.notesModel?.title,
            description: widget.notesModel?.description,
            createdAt: widget.notesModel?.createdAt,
            updatedAt: DateTime.now(),
            deletedAt: widget.notesModel?.deletedAt,
            isBookmarked: widget.notesModel?.isBookmarked,
            categoryId: _selectedIds.toList(),
          ),
        );

        notesCubit.filterByLabel(id);
      }
  }

  void _deleteCategory(String id) async {
    if (authCubit.currentUser == null) {
      return CustomSnackbarService.showError(context, 'No user found');
    }
    return await noteCategoriesCubit.deleteNoteCategory(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAddLabelToNote == true
          ? null
          :  CustomFloatingButton(
              onTap: () => context.push('/create-note-category'),
            ),
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

                    SizedBox(width: 8),
                    Text(
                      'Labels',
                      style: CustomTheme.typography(context).headlineSmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<NoteCategoriesCubit, NoteCategoriesState>(
                  builder: (context, state) {
                    if (state is NoteCategoriesLoaded) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 00, 16, 20),

                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '(${state.noteCategoriesModel.length.toString()})',
                                style: CustomTheme.typography(context)
                                    .bodyMedium
                                    .copyWith(
                                      color: CustomTheme.colors(
                                        context,
                                      ).tertiaryText,
                                    ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // List of Labels
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.noteCategoriesModel.length,
                                itemBuilder: (context, index) {
                                  final NoteCategoriesModel noteCategoryItem =
                                      state.noteCategoriesModel[index];

                                  return NotesCategoryItem(
                                    noteCategoryItem: noteCategoryItem,
                                    toggleSelection: _toggleSelection,
                                    deleteCategory: _deleteCategory,
                                    isSelected: _selectedIds.contains(noteCategoryItem.id),
                                    isAddLabelToNote: isAddLabelToNote,
                                   
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return CustomLoading();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
