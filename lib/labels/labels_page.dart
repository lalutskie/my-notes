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

import '../utils/custom_theme.dart';

class LabelsPage extends StatefulWidget {
  const LabelsPage({super.key});

  @override
  State<LabelsPage> createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  final Set<String> _selectedIds = {};
  late final noteCategoriesCubit = context.read<NoteCategoriesCubit>();
  late final authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    super.initState();
  }

  void _toggleSelection(String id) {
    setState(() {
      !_selectedIds.contains(id)
          ? _selectedIds.add(id)
          : _selectedIds.remove(id);
    });
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
      floatingActionButton: CustomFloatingButton(
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
