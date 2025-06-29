class RecordLocation {
  final double latitude;
  final double longitude;
  final String? address;   // (선택) 주소
  final String? placeName; // (선택) 장소명

  RecordLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  factory RecordLocation.fromJson(Map<String, dynamic> json) => RecordLocation(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        address: json['address'] as String?,
        placeName: json['placeName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'placeName': placeName,
      };
} 