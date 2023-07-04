import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:intl/intl.dart';

class AssignedChallenges {
  int? id;
  ChallengeModel? challengeModel;
  DateTime? startDate;
  DateTime? endDate;
  int? currentProgress;
  int? maxProgress;
  bool? isCompleted;

  AssignedChallenges(int id, ChallengeModel challengeModel, DateTime startDate, DateTime endDate, int currentProgress, int maxProgress, bool isCompleted) {
    this.id = id;
    this.challengeModel = challengeModel;
    this.startDate = startDate;
    this.endDate = endDate;
    this.currentProgress = currentProgress;
    this.maxProgress = maxProgress;
    this.isCompleted = isCompleted;
  }

  static List<AssignedChallenges> fromList(List<dynamic> json) {
    List<AssignedChallenges> challenges = [];
    json.forEach((element) {
      AssignedChallenges challenge = AssignedChallenges(
          element['id'],
          ChallengeModel.fromJson(element['challengeDatabase']),
          parseDate(element['startDate']),
          parseDate(element['endDate']),
          element['currentProgress'],
          element['maxProgress'],
          element['isCompleted'],
      );
      challenges.add(challenge);
    });
    return challenges;
  }

  factory AssignedChallenges.fromJson(Map<String, dynamic> json) {
    return AssignedChallenges(
      json['id'],
      ChallengeModel.fromJson(json['challengeDatabase']),
      parseDate(json['startDate']),
      parseDate(json['endDate']),
      json['currentProgress'],
      json['maxProgress'],
      json['isCompleted'],
    );
  }

  static DateTime parseDate(String date) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.parse(date);
  }

  @override
  String toString() {
    return 'AssignedChallenges{id: $id, challengeModel: $challengeModel, startDate: $startDate, endDate: $endDate, currentProgress: $currentProgress, maxProgress: $maxProgress, isCompleted: $isCompleted}';
  }
}