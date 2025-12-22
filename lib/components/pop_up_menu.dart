import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/custom_theme.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'Menu',
      elevation: 1,
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => context.push('/archived-notes'),
          child: Text(
            'Archives',
            style: CustomTheme.typography(context).bodyMedium.copyWith(
              color: CustomTheme.colors(context).primaryText,
            ),
          ),
        ),

        PopupMenuItem(
          onTap: () {
            context.push('/favorites');
          },
          child: Text(
            'Favorites',
            style: CustomTheme.typography(context).bodyMedium.copyWith(
              color: CustomTheme.colors(context).primaryText,
            ),
          ),
        ),

        PopupMenuItem(
          onTap: () {
            context.push('/labels');
          },
          child: Text(
            'Labels',
            style: CustomTheme.typography(context).bodyMedium.copyWith(
              color: CustomTheme.colors(context).primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
