
import 'package:flutter/material.dart';

extension CustomSpaceWidget on List<Widget> {
  Widget column({
    double spacing = 0,
    double startSpacing = 0,
    double endSpacing = 0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        if(startSpacing > 0) SizedBox(height: startSpacing,),
        ..._withSpacing(axis: Axis.horizontal, spacing: spacing),
        if(startSpacing > 0) SizedBox(height: startSpacing,),
      ],
    );
  }

  /// Divide children in a Row with spacing
  Widget row({
    double spacing = 0,
    double startSpacing = 0,
    double endSpacing = 0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        if (startSpacing > 0) SizedBox(width: startSpacing),
        ..._withSpacing(axis: Axis.horizontal, spacing: spacing),
        if (endSpacing > 0) SizedBox(width: endSpacing),
      ],
    );
  }

  List<Widget> _withSpacing({required Axis axis, double spacing = 0}) {
    if (isEmpty) return [];

    return [
      for (int i = 0; i < length; i++) ...[
        this[i],
        if (i != length - 1)
          axis == Axis.vertical
              ? SizedBox(height: spacing)
              : SizedBox(width: spacing),
      ]
    ];
  }
}