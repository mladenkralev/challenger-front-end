import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/shared/time/TagTransformer.dart';

class ChallengeModel {
  int? id;
  String? title;
  String? description;
  String? shortDescription;
  Occurrences? occurrences;
  NetworkBlob? blob;
  List<Tag>? badges;

  ChallengeModel({
    this.id,
    this.title,
    this.description,
    this.shortDescription,
    this.occurrences,
    this.blob,
    this.badges, // Add this parameter
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> badgeJson =
        json['badges']; // This is the incoming JSON for badges
    List<Tag> badgeList = badgeJson
        .map((badge) => TagTransformer.getEnumTag(badge.toString()))
        .toList(); // Transform to List<Tag>

    return ChallengeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      shortDescription: json['shortDescription'],
      occurrences: OccurrencesTransformer.getEnumOccurrences(json['occurrences']),
      blob: getNetworkBlob(json['streamingFileRecord']),
      badges: badgeList, // Set the transformed list
    );
  }

  static List<ChallengeModel> fromList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChallengeModel.fromJson(json)).toList();
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
