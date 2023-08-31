import 'package:challenger/shared/model/ChallengeModel.dart';

import '../model/AssignedChallenges.dart';
import '../model/UserModel.dart';

class UserManagerService {
  User? user;

  static const String ASSIGNED_CHALLENGES = "assignedToUserChallenges";
  static const String CREATED_CHALLENGES = "createdByUserChallenges";

  UserManagerService attachUser(User user) {
    this.user = user;
    return this;
  }

  assignChallenge(AssignedChallenges challenge) {
    user?.challengeManager?.assignChallenge(challenge);
  }

  abandonChallenge(AssignedChallenges challenge) {
    user?.challengeManager?.abandonChallenge(ASSIGNED_CHALLENGES, challenge);
  }

  List<AssignedChallenges>? getAssignChallenges() {
    return user?.challengeManager?.getChallenges(ASSIGNED_CHALLENGES);
  }

  List<AssignedChallenges>? getCompletedChallenges() {
    return user?.challengeManager?.getChallenges(ASSIGNED_CHALLENGES);
  }

  List<AssignedChallenges>? getDailyAssignChallenges() {
    return user?.challengeManager?.getDailyChallenges(ASSIGNED_CHALLENGES);
  }

  List<AssignedChallenges>? getWeeklyAssignChallenges() {
    return user?.challengeManager?.getWeeklyChallenges(ASSIGNED_CHALLENGES);
  }

  List<AssignedChallenges>? getMonthlyAssignChallenges() {
    return user?.challengeManager?.getMonthlyChallenges(ASSIGNED_CHALLENGES);
  }

  User? get hasUser => user ?? null;

  int? get level => user?.level;

  String? get email => user?.email;

  String? get username => user?.username;

  String? get title => user?.title;
}
