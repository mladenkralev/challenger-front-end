import 'dart:typed_data';

import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/user/user.dart';
import 'package:flutter/cupertino.dart';

import '../time/occurrences.dart';

class UserManager {

  User user;

  static const String ASSIGNED_CHALLENGES = "assignedToUserChallenges";
  static const String CREATED_CHALLENGES = "createdByUserChallenges";


  factory UserManager.empty() {
    return UserManager._internal(null);
  }
  UserManager._internal(this.user);

  UserManager attachUser(User user) {
    this.user = user;
    return this;
  }

  assignChallenge(Challenge challenge) {
    user.challengeManager.assignChallenge(challenge);
  }

  abandonChallenge(Challenge challenge) {
   user.challengeManager.abandonChallenge(ASSIGNED_CHALLENGES, challenge);
  }

  List<Challenge> getAssignChallenges() {
    return user.challengeManager.getChallenges(ASSIGNED_CHALLENGES);
  }

  Future<List<Challenge>> dummyMethod() {
    return Future<
        List<Challenge>>.delayed(
        const Duration(seconds: 2),
            () =>
            List.generate(10, (index) =>
            new Challenge(0, "Test", "test", Occurrences.DAY, DateTime.now(),
                DateTime.now())
            ));
  }
  List<Challenge> getCompletedChallenges() {
    return user.challengeManager.getChallenges(ASSIGNED_CHALLENGES);
  }

  List<Challenge> getDailyAssignChallenges()  {
    return user.challengeManager.getDailyChallenges(ASSIGNED_CHALLENGES);
  }

  List<Challenge> getWeeklyAssignChallenges()  {
    return user.challengeManager.getMonthlyChallenges(ASSIGNED_CHALLENGES);
  }

  List<Challenge> getMonthlyAssignChallenges()  {
    return user.challengeManager.getMonthlyChallenges(ASSIGNED_CHALLENGES);
  }

  User get hasUser => user ?? null;

  int get level => user.level;

  String get email => user.email;

  String get username => user.username;

  String get title => user.title;
}