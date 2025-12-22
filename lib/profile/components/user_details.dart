import 'package:flutter/material.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';

import '../../utils/custom_theme.dart';
import '../../utils/text_utils.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, required this.currentUser});

  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TextUtils.capitalizeEachWord(currentUser?.name ?? 'Name name'),
          style: CustomTheme.typography(context).headlineSmall.copyWith(
            color: CustomTheme.colors(context).primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          currentUser?.email ?? 'Your email',
          style: CustomTheme.typography(context).bodyMedium.copyWith(
            color: CustomTheme.colors(context).tertiaryText,
          ),
        ),
      ],
    );
  }
}
