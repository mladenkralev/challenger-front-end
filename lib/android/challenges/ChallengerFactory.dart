import 'package:challenger/android/challenges/ChallengeProgress.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';


class ChallengerFactory {
  List<ChallengeProgress> _progress = [];

  static final Map<String, List<ChallengeModel> > _cache = <String, List<ChallengeModel> >{};

  List<ChallengeModel> addChallenges(String nameOfChallenges, List<ChallengeModel> challenges) {
    _cache.clear();
    return _cache.putIfAbsent( nameOfChallenges, () => challenges);
  }

  List<ChallengeModel> getChallenges(String nameOfChallenges) {
    List<ChallengeModel> list = _cache[nameOfChallenges];
    return list;
  }

  List<ChallengeModel> getDailyChallenges(String nameOfChallenges) {
    List<ChallengeModel> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.DAY)
        .toList();
    if(list.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  List<ChallengeModel> getWeeklyChallenges(String nameOfChallenges)  {
    List<ChallengeModel> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.WEEK)
        .toList();
    if(list.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  List<ChallengeModel> getMonthlyChallenges(String nameOfChallenges) {
    List<ChallengeModel> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.MONTH)
        .toList();
    if(list.isEmpty) {
      return List.empty(growable: true);
    }
    return list;
  }

  updateStatus(ChallengeModel challenge, bool isCompleted) {
    _progress.forEach((element) => {
          if (element.challenge == challenge)
            {element.updateProgress(isCompleted)}
        });
  }

  void createUserChallenge(ChallengeModel challenge) {

  }

  void abandonChallenge(String nameOfChallenges, ChallengeModel challenge) {
    if (_cache[nameOfChallenges].contains(challenge)) {
      _cache[nameOfChallenges].remove(challenge);
    }
  }

  void assignChallenge(ChallengeModel challenge) {

  }

}
