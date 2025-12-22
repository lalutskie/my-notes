
import 'package:flutter/material.dart';
import '../utils/custom_theme.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: CustomTheme.colors(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.add_rounded,
              color: CustomTheme.colors(context).primary,
            ),
          ),
        ),
      );
  }
}