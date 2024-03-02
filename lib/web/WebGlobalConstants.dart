
import 'package:flutter/material.dart';

class WebGlobalConstants {
  static final double titleSize = 22; // Used for significant, standalone titles
  static final double cardTitleSize = 18; // Titles within cards or less prominent sections
  static final double h1Size = 24; // Main headings within content sections
  static final double h2Size = 22; // Secondary headings, less prominent than h1
  static final double tagSize = 18; // Secondary headings, less prominent than h1

  static final Color primaryColor = Colors.white;
  static final Color foregroundColor = Colors.black12;
  static final Color hardBlack = Colors.black;
  static final Color secondBlack = Colors.black87;
  static final Color secondaryColor = Colors.white60;
  static final ColorScheme colorScheme = ColorScheme.fromSwatch().copyWith(secondary: secondaryColor);
  static final backgroundColor = Color(0xFFF9F6F4);

  static final double buttonFontSize = 20;
}