enum Tag {
  INTELLECT, STRENGTH, AGILITY,
  MONTHLY, DAILY, WEEKLY,
  HARD, MEDIUM, EASY
}

class TagTransformer {
  static Tag getEnumTag(String occurrences) {
    var upperCaseValue = occurrences.toUpperCase();

    switch(upperCaseValue) {
      case 'INTELLECT':
        return Tag.INTELLECT;
      case 'STRENGTH':
        return Tag.STRENGTH;
      case 'AGILITY':
        return Tag.AGILITY;
      case 'MONTHLY':
        return Tag.MONTHLY;
      case 'DAILY':
        return Tag.DAILY;
      case 'WEEKLY':
        return Tag.WEEKLY;
      case 'HARD':
        return Tag.HARD;
      case 'MEDIUM':
        return Tag.MEDIUM;
      case 'EASY':
        return Tag.EASY;
      default:
        throw Exception('Invalid tag value: $occurrences');
    }
  }

  static String toShortString(Tag tag) {
    // This method uses a switch case to convert enum cases to strings
    switch (tag) {
      case Tag.INTELLECT:
        return 'Intellect';
      case Tag.STRENGTH:
        return 'Strength';
      case Tag.AGILITY:
        return 'Agility';
      case Tag.MONTHLY:
        return 'Monthly';
      case Tag.DAILY:
        return 'Daily';
      case Tag.WEEKLY:
        return 'Weekly';
      case Tag.HARD:
        return 'Hard';
      case Tag.MEDIUM:
        return 'Medium';
      case Tag.EASY:
        return 'Easy';
      default:
        return 'Unknown';
    }
  }
}
