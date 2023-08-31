import 'package:challenger/android/challenges/ChallengerFactory.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';

class User {
  int? _id;
  int? _level;
  String? _email;
  String? _username;
  String? _title;
  String? _jwtToken;

  ChallengerFactory? challengeManager;

  static const String ASSIGNED_CHALLENGES = "assignedToUserChallenges";
  static const String CREATED_CHALLENGES = "createdByUserChallenges";

  User(Map<String, dynamic> json, String token) {
    _id = json['id'];
    _email = json['email'];
    _username = json['username'];
    _jwtToken = token;
    // challengeManager = createUserChallengeManager(json);
    }

  static ChallengerFactory createUserChallengeManager(
      Map<String, dynamic> json) {
    ChallengerFactory challengerFactory = new ChallengerFactory();
    var createdByUserChallenges = ChallengeModel.fromList(json["createdByUserChallenges"]);
    print("Created by user challenges fetching " + createdByUserChallenges.toString());

    var assignedToUserChallenges = AssignedChallenges.fromList(json["assignedToUserChallenges"]);

    assignedToUserChallenges.forEach((element) {
      print('Assigned Challenge ' + element.toString());
    });

    // challengerFactory.addChallenges(CREATED_CHALLENGES, createdByUserChallenges);
    challengerFactory.addChallenges(ASSIGNED_CHALLENGES, assignedToUserChallenges);

    var dailyChallenges = challengerFactory.getDailyChallenges("assignedToUserChallenges");
    return challengerFactory;
  }

  ChallengerFactory? get manager => challengeManager;

  int get id => _id ?? -1;

  int get level => _level ?? 1;

  String get email => _email ?? "dummy@notfound.com";

  String get token => _jwtToken ?? "invalid_token";

  String get username => _username ?? "Dummy";

  String get title => _title ?? "Unknown";
}
