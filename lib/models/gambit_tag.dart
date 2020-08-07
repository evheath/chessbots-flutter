import 'package:flutter/material.dart';

/// Describes aspects of a gambits
class GambitTag {
  IconData icon;
  Color color;
  Color secondaryColor;

  GambitTag({
    @required this.icon,
    @required this.color,
    this.secondaryColor,
  });
}
