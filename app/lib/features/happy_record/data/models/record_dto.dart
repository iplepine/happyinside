import 'package:hive/hive.dart';
import '../../../../core/models/record.dart';
import 'record_location_dto.dart';
import 'record_photo_dto.dart';

part 'record_dto.g.dart';

@HiveType(typeId: 0)
class RecordDto extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String content;
  @HiveField(2)
  int intensity;
  @HiveField(3)
  List<String> tags;
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  RecordLocationDto? location;
  @HiveField(6)
  List<RecordPhotoDto> photos;

  RecordDto({
    required this.id,
    required this.content,
    required this.intensity,
    required this.tags,
    required this.createdAt,
    this.location,
    this.photos = const [],
  });

  factory RecordDto.fromDomain(Record record) => RecordDto(
        id: record.id,
        content: record.content,
        intensity: record.intensity,
        tags: List<String>.from(record.tags),
        createdAt: record.createdAt,
        location: record.location != null ? RecordLocationDto.fromDomain(record.location!) : null,
        photos: record.photos.map((e) => RecordPhotoDto.fromDomain(e)).toList(),
      );

  Record toDomain() => Record(
        id: id,
        content: content,
        intensity: intensity,
        tags: List<String>.from(tags),
        createdAt: createdAt,
        location: location?.toDomain(),
        photos: photos.map((e) => e.toDomain()).toList(),
      );
} 