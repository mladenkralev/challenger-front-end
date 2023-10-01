import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:intl/intl.dart';

class StatisticsModel {
  int? thisWeekCompleted;
  int? thisWeekAssigned;
  int? lastWeekAssigned;
  int? lastWeekCompleted;
  int? thisWeekNewChallenges;

  StatisticsModel(
      this.thisWeekCompleted,
      this.thisWeekAssigned,
      this.lastWeekAssigned,
      this.lastWeekCompleted,
      this.thisWeekNewChallenges);

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      json['thisWeekCompleted'],
      json['thisWeekAssigned'],
      json['lastWeekAssigned'],
      json['lastWeekCompleted'],
      json['thisWeekNewChallenges'],
    );
  }


}