import 'package:flutter/material.dart';
import 'package:hive_firebase/components/notes_category_textfield.dart';

import '../features/note_categories/domain/model/note_categories_model.dart';

import '../utils/custom_theme.dart';

class NotesCategoryItem extends StatelessWidget {
  const NotesCategoryItem({
    super.key,
    required this.noteCategoryItem,
    required this.toggleSelection,
    required this.deleteCategory,
    required this.isSelected,
    this.isAddLabelToNote, 
  });

  final NoteCategoriesModel noteCategoryItem;
  final void Function(String id) toggleSelection;
  final void Function(String id) deleteCategory;
  final bool isSelected;
  final bool? isAddLabelToNote;

  @override
  Widget build(BuildContext context) {
    final bool isAddMode = isAddLabelToNote ?? false;

    final bool showDelete = !isAddMode && isSelected;
    final bool showCheckbox = isAddMode;
    final bool showEditableText = !isAddMode && isSelected;
    final bool showEditButton = !isAddMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          spacing: 8,
          children: [
            if (showDelete)
              GestureDetector(
                onTap: () => deleteCategory(noteCategoryItem.id),
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: CustomTheme.colors(context).error,
                ),
              ),

            if (showCheckbox)
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == null) return;
                  toggleSelection(noteCategoryItem.id);
                },
                activeColor: CustomTheme.colors(context).primary,
              ),

            Expanded(
              child: showEditableText
                  ? NotesCategoryTextfield(
                      noteCategoriesModel: noteCategoryItem,
                    )
                  : Text(
                      noteCategoryItem.name,
                      style: CustomTheme.typography(context).bodyMedium
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: CustomTheme.colors(context).primaryText,
                          ),
                    ),
            ),

            if (showEditButton)
              GestureDetector(
                onTap: () => toggleSelection(noteCategoryItem.id),
                child: Icon(
                  isSelected ? Icons.close : Icons.edit_outlined,
                  color: CustomTheme.colors(context).primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
