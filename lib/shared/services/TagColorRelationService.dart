import 'package:challenger/shared/time/TagTransformer.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart' as flutterColor;
import 'package:community_charts_common/src/common/palette.dart';

class TagColorRelationService {
  flutterColor.Color getColorForTag(Tag badge) {
    switch (badge) {
      case Tag.STRENGTH:
        return flutterColor.Colors.red;
      case Tag.AGILITY:
        return flutterColor.Colors.green;
      case Tag.INTELLECT:
        return flutterColor.Colors.blue;
      case Tag.MONTHLY:
        return flutterColor.Colors.purple;
      case Tag.DAILY:
        return flutterColor.Colors.deepOrange;
      case Tag.WEEKLY:
        return flutterColor.Colors.lime;
      case Tag.HARD:
        return flutterColor.Colors.teal;
      case Tag.MEDIUM:
        return flutterColor.Colors.yellow;
      case Tag.EASY:
        return flutterColor.Colors.indigo;
      default:
        return flutterColor.Colors.pink; // Default color for unspecified tags
    }
  }

  Palette getColorForChart(Tag badge) {
    switch (badge) {
      case Tag.STRENGTH:
        return MaterialPalette.red;
      case Tag.AGILITY:
        return MaterialPalette.green;
      case Tag.INTELLECT:
        return MaterialPalette.blue;
      case Tag.MONTHLY:
        return MaterialPalette.purple;
      case Tag.DAILY:
        return MaterialPalette.deepOrange;
      case Tag.WEEKLY:
        return MaterialPalette.lime;
      case Tag.HARD:
        return MaterialPalette.teal;
      case Tag.MEDIUM:
        return MaterialPalette.yellow;
      case Tag.EASY:
        return MaterialPalette.indigo;
      default:
        return MaterialPalette.pink; // Default color for unspecified tags
    }
  }
}
