import 'package:challenger/shared/model/ChallengeModel.dart';

import 'UserModel.dart';

class UserManager {
  User user;

  static const String ASSIGNED_CHALLENGES = "assignedToUserChallenges";
  static const String CREATED_CHALLENGES = "createdByUserChallenges";

  UserManager attachUser(User user) {
    this.user = user;
    return this;
  }

  assignChallenge(ChallengeModel challenge) {
    user.challengeManager.assignChallenge(challenge);
  }

  abandonChallenge(ChallengeModel challenge) {
    user.challengeManager.abandonChallenge(ASSIGNED_CHALLENGES, challenge);
  }

  List<ChallengeModel> getAssignChallenges() {
    return user.challengeManager.getChallenges(ASSIGNED_CHALLENGES);
  }

  List<ChallengeModel> getCompletedChallenges() {
    return user.challengeManager.getChallenges(ASSIGNED_CHALLENGES);
  }

  List<ChallengeModel> getDailyAssignChallenges() {
    return user.challengeManager.getDailyChallenges(ASSIGNED_CHALLENGES);
  }

  List<ChallengeModel> getWeeklyAssignChallenges() {
    return user.challengeManager.getWeeklyChallenges(ASSIGNED_CHALLENGES);
  }

  List<ChallengeModel> getMonthlyAssignChallenges() {
    return user.challengeManager.getMonthlyChallenges(ASSIGNED_CHALLENGES);
  }

  User get hasUser => user ?? null;

  int get level => user.level;

  String get email => user.email;

  String get username => user.username;

  String get title => user.title;
}
