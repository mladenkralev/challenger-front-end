import 'challenge.dart';
import 'http_data_initializator.dart';

// class AllChallengeTaskManager {
//   static int counter = 0;
//
//   //Private Constructor
//   AllChallengeTaskManager._();
//
//   List<Challenge> challenges = new List();
//
//   static AllChallengeTaskManager _instance;
//
//   factory AllChallengeTaskManager.instance() {
//     if (_instance == null) {
//       _instance = AllChallengeTaskManager._();
//       HttpDataInitializator.allChallenges.then(
//           (value) => AllChallengeTaskManager._instance.challenges.addAll(value));
//     }
//     return _instance;
//   }
//
//   addChallenge(Challenge challenge) {
//     challenge.id = counter++;
//     this.challenges.add(challenge);
//   }
//
//   List<Challenge> getChallenges() {
//     return this.challenges;
//   }
//
//   Challenge getChallenge(int index) {
//     return this.challenges.elementAt(index);
//   }
// }
