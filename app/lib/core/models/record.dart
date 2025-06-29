import 'record_location.dart';
import 'record_photo.dart';

class Record {
  final String id;
  final String content;
  final int intensity;
  final List<String> tags;
  final DateTime createdAt;
  final RecordLocation? location; // 위치 정보 (선택)
  final List<RecordPhoto> photos; // 사진 정보 (0개 이상)

  Record({
    required this.id,
    required this.content,
    required this.intensity,
    required this.tags,
    required this.createdAt,
    this.location,
    this.photos = const [],
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json['id'] as String,
        content: json['content'] as String,
        intensity: json['intensity'] as int,
        tags: List<String>.from(json['tags'] as List),
        createdAt: DateTime.parse(json['createdAt'] as String),
        location: json['location'] != null
            ? RecordLocation.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        photos: (json['photos'] as List<dynamic>?)
                ?.map((e) => RecordPhoto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'intensity': intensity,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'location': location?.toJson(),
        'photos': photos.map((e) => e.toJson()).toList(),
      };
} 