import 'package:flutter/material.dart';

import '../utils/custom_theme.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    super.key,
    required this.function,
    required this.leadIcon,
    required this.trailIcon,
    required this.name,
  });

  final void Function() function;
  final IconData leadIcon;
  final IconData trailIcon;
  final String name;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomTheme.colors(context).secondaryBackground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          spacing: 8,
          children: [
            SizedBox(width: 8),

            Icon(leadIcon),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: CustomTheme.typography(context).bodyMedium.copyWith(
                      color: CustomTheme.colors(context).tertiaryText,
                    ),
                  ),
                  Icon(trailIcon),
                ],
              ),
            ),

            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
