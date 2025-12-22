import 'package:flutter/material.dart';
import 'package:hive_firebase/components/note_category_chip.dart';
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';

import '../utils/custom_theme.dart';

class NotesCategoryList extends StatelessWidget {
  const NotesCategoryList({
    super.key,
    required this.noteCategoriesList,
    required this.onSelected,
    this.currentSelectedId,
  });

  final List<NoteCategoriesModel> noteCategoriesList;
  final ValueChanged<String?> onSelected;
  final String? currentSelectedId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: noteCategoriesList.length + 1,
        primary: false,
        itemBuilder: (context, index) {
          if (index == 0) {
            return NoteCategoryChip(
              labelName: 'All',
              categoryId: null,
              isSelected: currentSelectedId == null,
              onTap: () => onSelected(null),

            );
          }

          final NoteCategoriesModel noteCategoryItem =
              noteCategoriesList[index - 1];
          return NoteCategoryChip(
            labelName: noteCategoryItem.name,
            categoryId: noteCategoryItem.id,
            isSelected: currentSelectedId == noteCategoryItem.id,
            onTap: () => onSelected(noteCategoryItem.id),
          );
        },
      ),
    );
  }
}
