import 'package:flutter/material.dart';

import '../utils/custom_theme.dart';

class NoteCategoryChip extends StatelessWidget {
  const NoteCategoryChip({super.key, required this.labelName, this.categoryId, required this.onTap, required this.isSelected});

  final String labelName;
  final String? categoryId;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isSelected ? CustomTheme.colors(context).primary : Colors.white,
            border: BoxBorder.all(
              color: CustomTheme.colors(context).primary,
              width: 1,
            ),
          ),
          child: Text(
            labelName,
            style: CustomTheme.typography(context).bodyMedium.copyWith(
              color: isSelected ?  CustomTheme.colors(context).secondaryText :  CustomTheme.colors(context).primaryText,
            ),
          ),
        ),
      ),
    );
  }
}
