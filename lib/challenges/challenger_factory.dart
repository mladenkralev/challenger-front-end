import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/challenges/http_data_initializator.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:challenger/challenges/challenger_progressor.dart';
import 'package:flutter/cupertino.dart';

class ChallengerFactory {
  List<ChallengeProgress> _progress = [];

  static final Map<String, List<Challenge> > _cache = <String, List<Challenge> >{};

  List<Challenge> addChallenges(String nameOfChallenges, List<Challenge> challenges) {
    _cache.clear();
    return _cache.putIfAbsent( nameOfChallenges, () => challenges);
  }

  List<Challenge> getChallenges(String nameOfChallenges) {
    List<Challenge> list = _cache[nameOfChallenges];
    return list;
  }

  List<Challenge> getDailyChallenges(String nameOfChallenges) {
    List<Challenge> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.DAY)
        .toList();
    return list;
  }

  List<Challenge> getWeeklyChallenges(String nameOfChallenges)  {
    List<Challenge> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.WEEK)
        .toList();
    return list;
  }

  List<Challenge> getMonthlyChallenges(String nameOfChallenges) {
    List<Challenge> list = _cache[nameOfChallenges]
        .where((element) => element.occurrences == Occurrences.MONTH)
        .toList();
    return list;
  }

  updateStatus(Challenge challenge, bool isCompleted) {
    _progress.forEach((element) => {
          if (element.challenge == challenge)
            {element.updateProgress(isCompleted)}
        });
  }

  void createUserChallenge(Challenge challenge) {

  }

  void abandonChallenge(String nameOfChallenges, Challenge challenge) {
    if (_cache[nameOfChallenges].contains(challenge)) {
      _cache[nameOfChallenges].remove(challenge);
    }
  }

  void assignChallenge(Challenge challenge) {

  }

}
