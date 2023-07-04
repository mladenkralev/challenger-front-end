import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:intl/intl.dart';

import 'AssignedChallenges.dart';

class HistoryChallenge {
  DateTime? progressDate;
  AssignedChallenges? assignedChallenges;

  HistoryChallenge(DateTime progressDate, AssignedChallenges assignedChallenges) {
    this.progressDate = progressDate;
    this.assignedChallenges = assignedChallenges;
  }

  @override
  String toString() {
    return 'HistoryChallenge{progressDate: $progressDate, assignedChallenges: $assignedChallenges}';
  }
}
