import 'package:hive/hive.dart';
import '../../../../core/models/record_photo.dart';

part 'record_photo_dto.g.dart';

@HiveType(typeId: 2)
class RecordPhotoDto extends HiveObject {
  @HiveField(0)
  String path;
  @HiveField(1)
  String? thumbnail;

  RecordPhotoDto({
    required this.path,
    this.thumbnail,
  });

  factory RecordPhotoDto.fromDomain(RecordPhoto photo) => RecordPhotoDto(
        path: photo.path,
        thumbnail: photo.thumbnail,
      );

  RecordPhoto toDomain() => RecordPhoto(
        path: path,
        thumbnail: thumbnail,
      );
} 