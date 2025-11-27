import 'package:flutter/material.dart';
import 'package:hive_firebase/utils/custom_theme.dart';

class CustomBackButton extends StatefulWidget {
  const CustomBackButton({super.key, this.function});

  final void Function()? function;

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(child: Icon(Icons.chevron_left, color: CustomTheme.colors(context).primary,)),
      ),
    );
  }
}