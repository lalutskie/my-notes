import 'package:flutter/material.dart';

import '../../components/custom_menu_button.dart';

class ProfileMenus extends StatelessWidget {
  const ProfileMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomMenuButton(
          function: () {},
          leadIcon: Icons.edit_outlined,
          trailIcon: Icons.chevron_right_rounded,
          name: 'Update Profile',
        ),

        SizedBox(height: 8),

        CustomMenuButton(
          function: () {},
          leadIcon: Icons.settings_outlined,
          trailIcon: Icons.chevron_right_rounded,
          name: 'Settings',
        ),
      ],
    );
  }
}
