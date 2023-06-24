import 'package:challenger/android/challenges/ChallengeProgress.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';


class ChallengerFactory {
  List<ChallengeProgress> _progress = [];

  static final Map<String, List<AssignedChallenges> > _cache = <String, List<AssignedChallenges> >{};

  List<AssignedChallenges> addChallenges(String nameOfChallenges, List<AssignedChallenges> challenges) {

    if(_cache.containsKey(nameOfChallenges)) {
      _cache.remove(nameOfChallenges);
    }

    var putIfAbsent = _cache.putIfAbsent( nameOfChallenges, () => challenges);
    return putIfAbsent;
  }

  List<AssignedChallenges> getChallenges(String nameOfChallenges) {
    List<AssignedChallenges> list = _cache[nameOfChallenges]!;
    return list;
  }

  List<AssignedChallenges> getDailyChallenges(String nameOfChallenges) {
    List<AssignedChallenges>? list = _cache[nameOfChallenges]
        ?.where((element) => element.challengeModel?.occurrences! == Occurrences.DAY)
        .toList();
    if(list!.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  List<AssignedChallenges> getWeeklyChallenges(String nameOfChallenges)  {
    List<AssignedChallenges>? list = _cache[nameOfChallenges]
        ?.where((element) => element.challengeModel?.occurrences == Occurrences.WEEK)
        .toList();
    if(list!.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  List<AssignedChallenges> getMonthlyChallenges(String nameOfChallenges) {
    List<AssignedChallenges>? list = _cache[nameOfChallenges]
        ?.where((element) => element.challengeModel?.occurrences! == Occurrences.MONTH)
        .toList();
    if(list!.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  updateStatus(AssignedChallenges challenge, bool isCompleted) {
    _progress.forEach((element) => {
          if (element.challenge == challenge)
            {element.updateProgress(isCompleted)}
        });
  }

  void createUserChallenge(AssignedChallenges challenge) {

  }

  void abandonChallenge(String nameOfChallenges, AssignedChallenges challenge) {
    if (_cache[nameOfChallenges]!.contains(challenge)) {
      _cache[nameOfChallenges]?.remove(challenge);
    }
  }

  void assignChallenge(AssignedChallenges challenge) {

  }

}
