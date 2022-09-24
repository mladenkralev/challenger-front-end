import 'package:challenger/android/challenges/ChallengerFactory.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';

class User {
  int _id;
  int _level;
  String _email;
  String _username;
  String _title;
  String _jwtToken;

  bool _active;
  ChallengerFactory challengeManager;

  static const String ASSIGNED_CHALLENGES = "assignedToUserChallenges";
  static const String CREATED_CHALLENGES = "createdByUserChallenges";

  User.fromJson(Map<String, dynamic> json, String token)
      : _id = json['id'],
        _email = json['email'],
        _username = json['username'],
        _active = json['active'],
        _jwtToken = token,
        challengeManager = createUserChallengeManager(json);

  static ChallengerFactory createUserChallengeManager(
      Map<String, dynamic> json) {
    var challengerFactory = new ChallengerFactory();
    challengerFactory.addChallenges(CREATED_CHALLENGES,
        ChallengeModel.fromList(json["createdByUserChallenges"]));
    challengerFactory.addChallenges(ASSIGNED_CHALLENGES,
        ChallengeModel.fromList(json["createdByUserChallenges"]));
    return challengerFactory;
  }

  ChallengerFactory get manager => challengeManager;

  int get level => _level ?? 1;

  String get email => _email ?? "dummy@notfound.com";

  String get token => _jwtToken ?? "invalid_token";

  String get username => _username ?? "Dummy";

  String get title => _title ?? "Unknown";
}
