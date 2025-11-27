import 'package:hive_firebase/utils/custom_theme.dart';

import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          color: CustomTheme.colors(context).primary,
        ),
      ),
    );
  }
}
