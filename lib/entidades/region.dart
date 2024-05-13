import 'dart:convert';

class Region {
  int? id;
  String? region;
  DateTime? createdAt;
  DateTime? updatedAt;

  Region({this.id, this.region, this.createdAt, this.updatedAt});

  @override
  String toString() {
    return 'Region(id: $id, region: $region, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Region.fromMap(Map<String, dynamic> data) => Region(
        id: data['id'] as int?,
        region: data['region'] as String?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'region': region,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Region].
  factory Region.fromJson(String data) {
    return Region.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Region] to a JSON string.
  String toJson() => json.encode(toMap());

  Region copyWith({
    int? id,
    String? region,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Region(
      id: id ?? this.id,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
