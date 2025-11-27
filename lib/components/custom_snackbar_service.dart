import 'package:hive_firebase/app.dart';
import 'package:hive_firebase/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomSnackbarService {
  static void showError(BuildContext context, String message) {
    rootScaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: CustomTheme.colors(context).error,
          content: Text(
            message,
            style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: CustomTheme.colors(context).secondaryText,
                ),
          ),
        ),
      );
  }

  static void showSuccess(BuildContext context, String message) {
    rootScaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: CustomTheme.colors(context).success,
          content: Text(
            message,
            style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: CustomTheme.colors(context).secondaryText,
                ),
          ),
        ),
      );
  }
}