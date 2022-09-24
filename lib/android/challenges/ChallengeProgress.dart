import 'package:challenger/shared/model/ChallengeModel.dart';

class ChallengeProgress {
  ChallengeModel _challenge;

  List<int> _progress = [];

  ChallengeProgress(this._challenge);

  updateProgress(bool completed) {
    if (completed) {
      _progress.add(1);
    } else {
      _progress.add(0);
    }
  }

  ChallengeModel get challenge => _challenge;

  set challenge(ChallengeModel challenge) {
    _challenge = challenge;
  }
}
