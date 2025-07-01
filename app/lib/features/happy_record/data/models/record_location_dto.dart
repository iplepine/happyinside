import 'package:hive/hive.dart';
import '../../../../core/models/record_location.dart';

part 'record_location_dto.g.dart';

@HiveType(typeId: 1)
class RecordLocationDto extends HiveObject {
  @HiveField(0)
  double latitude;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  String? address;
  @HiveField(3)
  String? placeName;

  RecordLocationDto({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  factory RecordLocationDto.fromDomain(RecordLocation location) => RecordLocationDto(
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        placeName: location.placeName,
      );

  RecordLocation toDomain() => RecordLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
        placeName: placeName,
      );
} 