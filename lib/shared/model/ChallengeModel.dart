import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:intl/intl.dart';

class ChallengeModel {
  int id;
  String title;
  String description;

  Occurrences occurrences;
  DateTime startDate;
  DateTime finalDate;

  double numberOfProgressHits;
  NetworkBlob blob;

  ChallengeModel(int id, String title, String description, Occurrences occurrences,
      DateTime startDate, DateTime endDate, double numberOfProgressHits, NetworkBlob blob) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.occurrences = occurrences;
    this.startDate = startDate;
    this.finalDate = endDate;
    this.numberOfProgressHits = numberOfProgressHits;
    this.blob = blob;
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
        json['id'],
        json['title'],
        json['description'],
        json['occurrences'],
        json['startDate'],
        json['endDate'],
        json['numberOfProgressHits'],
        json['streamingFileRecord']
    );
  }

  static List<ChallengeModel> fromList(List<dynamic> json) {
    List<ChallengeModel> challenges = [];
    json.forEach((element) {
      ChallengeModel challenge = ChallengeModel(
                element['id'],
                element['title'],
                element['description'],
                OccurrencesTransformer.getEnumOccurrences(element['occurrences']),
                parseDate(element['startDate']),
                parseDate(element['endDate']),
                element['numberOfProgressHits'],
                getNetworkBlob(element['streamingFileRecord'])
      );
      challenges.add(challenge);
    });
    return challenges;
  }

  static NetworkBlob getNetworkBlob(dynamic json) {
   return NetworkBlob(json['id'], json['name'], json['gcsPath']);
  }

  static DateTime parseDate(String date) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.parse(date);
  }

  @override
  String toString() {
    return 'Challenge{id: $id, text: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          occurrences == other.occurrences &&
          startDate == other.startDate &&
          finalDate == other.finalDate;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      occurrences.hashCode ^
      startDate.hashCode ^
      finalDate.hashCode;
}

class NetworkBlob {
  int id;
  String name;
  String gcsPath;

  NetworkBlob(int id, String name, String gcsPath) {
    this.id = id;
    this.name = name;
    this.gcsPath = gcsPath;
  }

  factory NetworkBlob.fromJson(Map<String, dynamic> json) {
    return NetworkBlob(
        json['id'],
        json['name'],
        json['gcsPath'],
    );
  }
}
