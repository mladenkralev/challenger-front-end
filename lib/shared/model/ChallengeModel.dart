import 'package:challenger/shared/time/OccurrencesTransformer.dart';

class ChallengeModel {
  int? id;
  String? title;
  String? description;
  String? shortDescription;
  Occurrences? occurrences;
  NetworkBlob? blob;

  ChallengeModel(int id, String title, String description, String shortDescription, Occurrences occurrences, NetworkBlob blob) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.shortDescription = shortDescription;
    this.occurrences = occurrences;
    this.blob = blob;
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
        json['id'],
        json['title'],
        json['description'],
        json['shortDescription'],
        OccurrencesTransformer.getEnumOccurrences(json['occurrences']),
        getNetworkBlob(json['streamingFileRecord'])
    );
  }

  static List<ChallengeModel> fromList(List<dynamic> json) {
    List<ChallengeModel> challenges = [];
    json.forEach((element) {
      ChallengeModel challenge = ChallengeModel(
                element['id'],
                element['title'],
                element['description'],
                element['shortDescription'],
                OccurrencesTransformer.getEnumOccurrences(element['occurrences']),
                getNetworkBlob(element['streamingFileRecord'])
      );
      challenges.add(challenge);
    });
    return challenges;
  }

  static NetworkBlob getNetworkBlob(dynamic json) {
   return NetworkBlob(json['id'], json['name'], json['gcspath']);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          occurrences == other.occurrences;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      occurrences.hashCode;

  @override
  String toString() {
    return 'ChallengeModel{id: $id, title: $title, description: $description, occurrences: $occurrences';
  }
}

class NetworkBlob {
  int? id;
  String? name;
  String? gcsPath;

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
