enum Occurrences { DAY, WEEK, MONTH }

class OccurrencesTransformer {
  static Occurrences getEnumOccurrences(String occurrences) {
    var upperCaseValue = occurrences.toUpperCase();
    if (upperCaseValue ==
        Occurrences.DAY
            .toString()
            .substring(Occurrences.DAY.toString().indexOf('.') + 1)) {
      return Occurrences.DAY;
    }
    if (upperCaseValue ==
        Occurrences.MONTH
            .toString()
            .substring(Occurrences.MONTH.toString().indexOf('.') + 1)) {
      return Occurrences.MONTH;
    }
    if (upperCaseValue ==
        Occurrences.WEEK
            .toString()
            .substring(Occurrences.WEEK.toString().indexOf('.') + 1)) {
      return Occurrences.WEEK;
    }
    return Occurrences.DAY;
  }

  static String transformToString(Occurrences occurrences) {
    return occurrences
        .toString()
        .substring(occurrences.toString().indexOf('.') + 1);
  }

  static String toUiFormat(String incommingOccurrencesFormat) {
    switch (incommingOccurrencesFormat) {
      case "DAY":
        return "daily";
      case "WEEK":
        return "weekly";
      case "MONTH":
        return "monthly";
    }
    return "DAY";
  }
}
