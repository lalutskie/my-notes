
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';

import '../utils/custom_theme.dart';
import '../utils/text_utils.dart';

class NotesContainer extends StatelessWidget {
  const NotesContainer({super.key, required this.note, required this.isListArchived});

  final NotesModel note;
  final bool isListArchived;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.push(
          '/edit-note',
          extra: {'note': note, 'isArchived': isListArchived},
        ),
        child: Container(
          decoration: BoxDecoration(
            color: CustomTheme.colors(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 75,
          child: Stack(
            children: [
              if (note.isBookmarked ?? false)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: CustomTheme.colors(context).primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.bookmark_added_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title ?? 'no title',
                            style: CustomTheme.typography(context).bodyMedium
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.colors(context).primaryText,
                                ),
                          ),
                          Text(
                            note.description ?? 'no desc',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTheme.typography(context).bodySmall
                                .copyWith(
                                  color: CustomTheme.colors(context).tertiaryText,
                                ),
                          ),
      
                          Spacer(),
      
                          Text(
                            TextUtils.format(
                              date: !isListArchived
                                  ? note.updatedAt!
                                  : note.deletedAt!,
                            ),
                            style: CustomTheme.typography(context).bodySmall
                                .copyWith(
                                  color: CustomTheme.colors(context).tertiaryText,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}