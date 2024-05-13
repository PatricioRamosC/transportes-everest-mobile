import 'dart:convert';

import 'region.dart';

class Comuna {
  int? id;
  String? comuna;
  int? idRegion;
  DateTime? createdAt;
  DateTime? updatedAt;
  Region? region;

  Comuna({
    this.id,
    this.comuna,
    this.idRegion,
    this.createdAt,
    this.updatedAt,
    this.region,
  });

  @override
  String toString() {
    return 'Comuna(id: $id, comuna: $comuna, idRegion: $idRegion, createdAt: $createdAt, updatedAt: $updatedAt, region: $region)';
  }

  factory Comuna.fromMap(Map<String, dynamic> data) => Comuna(
        id: data['id'] as int?,
        comuna: data['comuna'] as String?,
        idRegion: data['id_region'] as int?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
        region: data['region'] == null
            ? null
            : Region.fromMap(data['region'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'comuna': comuna,
        'id_region': idRegion,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'region': region?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Comuna].
  factory Comuna.fromJson(String data) {
    return Comuna.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Comuna] to a JSON string.
  String toJson() => json.encode(toMap());

  Comuna copyWith({
    int? id,
    String? comuna,
    int? idRegion,
    DateTime? createdAt,
    DateTime? updatedAt,
    Region? region,
  }) {
    return Comuna(
      id: id ?? this.id,
      comuna: comuna ?? this.comuna,
      idRegion: idRegion ?? this.idRegion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      region: region ?? this.region,
    );
  }
}
