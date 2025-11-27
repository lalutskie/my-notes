import 'package:flutter/material.dart';


class CustomColumnSpacing extends StatelessWidget {
  const CustomColumnSpacing({
    super.key,
    required this.spacing,
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
  });

  final double spacing;
  final MainAxisAlignment? mainAxisAlignment ; 
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: children,
      );
    }
    
    List<Widget> spacedChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      // Add spacing between children (not after the last one)
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      children: spacedChildren,
    );
  }
}


