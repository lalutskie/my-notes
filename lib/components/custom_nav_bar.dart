import 'package:hive_firebase/components/custom_row_spacing.dart';
import 'package:hive_firebase/utils/custom_theme.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key, required this.currentPage});

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      height: 5,
      thickness: 2,
      color: CustomTheme.colors(context).primary,
    );

    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: CustomTheme.colors(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CustomRowSpacing(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 0,
        children: [
          
          InkWell(
            onTap: () => context.go('/home'),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPage == 'home') divider,

                  Icon(
                    Icons.home,
                    color: currentPage == 'home'
                        ? CustomTheme.colors(context).primary
                        : CustomTheme.colors(context).tertiaryText,
                  ),
                  Text(
                    'Home',
                    style: CustomTheme.typography(context).bodySmall.copyWith(
                      color: currentPage == 'home'
                          ? CustomTheme.colors(context).primary
                          : CustomTheme.colors(context).tertiaryText,
                      fontWeight: currentPage == 'home'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => context.go('/search'),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPage == 'search') divider,

                  Icon(
                    Icons.search,
                    color: currentPage == 'search'
                        ? CustomTheme.colors(context).primary
                        : CustomTheme.colors(context).tertiaryText,
                  ),
                  Text(
                    'Search',
                    style: CustomTheme.typography(context).bodySmall.copyWith(
                      color: currentPage == 'Search'
                          ? CustomTheme.colors(context).primary
                          : CustomTheme.colors(context).tertiaryText,
                      fontWeight: currentPage == 'Search'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => context.go('/profile'),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPage == 'profile') divider,

                  Icon(
                    Icons.person,
                    color: currentPage == 'profile'
                        ? CustomTheme.colors(context).primary
                        : CustomTheme.colors(context).tertiaryText,
                  ),
                  Text(
                    'Profile',
                    style: CustomTheme.typography(context).bodySmall.copyWith(
                      color: currentPage == 'profile'
                          ? CustomTheme.colors(context).primary
                          : CustomTheme.colors(context).tertiaryText,
                      fontWeight: currentPage == 'profile'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
