import 'package:hive_firebase/utils/custom_theme.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width,
    this.height,
    required this.text,
    this.function,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.icon,
    this.borderColor,
  });

  final double? width;
  final double? height;
  final String text;
  final void Function()? function;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final IconData? icon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? CustomTheme.colors(context).primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.0)
                : BorderSide.none,
          ),
          elevation: elevation ?? 0,
        ),
        onPressed: function,
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color:
                        textColor ?? CustomTheme.colors(context).secondaryText,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: CustomTheme.typography(context).bodyMedium.copyWith(
                      color:
                          textColor ??
                          CustomTheme.colors(context).secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: textColor ?? CustomTheme.colors(context).secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
