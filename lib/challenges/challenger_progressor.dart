import 'package:challenger/challenges/challenge.dart';

class ChallengeProgress {
  Challenge _challenge;

  List<int> _progress = [];

  ChallengeProgress(this._challenge);

  updateProgress(bool completed) {
    if (completed) {
      _progress.add(1);
    } else {
      _progress.add(0);
    }
  }

  Challenge get challenge => _challenge;

  set challenge(Challenge challenge) {
    _challenge = challenge;
  }
}
