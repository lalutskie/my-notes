import 'package:flutter/material.dart';
import 'package:hive_firebase/components/notes_category_textfield.dart';

import '../features/note_categories/domain/model/note_categories_model.dart';
import '../utils/custom_theme.dart';

class NotesCategoryItem extends StatelessWidget {
  const NotesCategoryItem({super.key, required this.noteCategoryItem, required this.toggleSelection, required this.deleteCategory, required this.isSelected});

  final NoteCategoriesModel noteCategoryItem;
  final void Function(String id) toggleSelection;
  final void Function(String id) deleteCategory;
  final bool isSelected;

    

  @override
  Widget build(BuildContext context) {
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
            if (isSelected)
              GestureDetector(
                onTap: () => deleteCategory(noteCategoryItem.id),
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: CustomTheme.colors(context).error,
                ),
              ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isSelected) {
                    return NotesCategoryTextfield(
                      noteCategoriesModel: noteCategoryItem,
                    );
                  }

                  return Text(
                    noteCategoryItem.name,
                    style: CustomTheme.typography(context).bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomTheme.colors(context).primaryText,
                    ),
                  );
                },
              ),
            ),

            GestureDetector(
              onTap: () => toggleSelection(noteCategoryItem.id),
              child: Icon(
                isSelected ? Icons.close :  Icons.edit_outlined,
                color: CustomTheme.colors(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}