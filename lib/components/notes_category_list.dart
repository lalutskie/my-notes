import 'package:flutter/material.dart';
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';

import '../utils/custom_theme.dart';

class NotesCategoryList extends StatefulWidget {
  const NotesCategoryList({super.key, required this.noteCategoriesList});

  final List<NoteCategoriesModel> noteCategoriesList;

  @override
  State<NotesCategoryList> createState() => _NotesCategoryListState();
}

class _NotesCategoryListState extends State<NotesCategoryList> {

  


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.noteCategoriesList.length,
        primary: false,
        itemBuilder: (context, index) {


          final NoteCategoriesModel noteCategoryItem = widget.noteCategoriesList[index];
          return Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: CustomTheme.colors(context).primary,
                border: BoxBorder.all(
                  color: CustomTheme.colors(context).primary,
                  width: 1,
                ),
              ),
              child: Text(
                noteCategoryItem.name,
                style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: CustomTheme.colors(context).secondaryText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
