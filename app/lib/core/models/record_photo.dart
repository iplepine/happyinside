class RecordPhoto {
  final String path;      // 로컬 파일 경로 또는 네트워크 URL
  final String? thumbnail; // (선택) 썸네일 경로

  RecordPhoto({
    required this.path,
    this.thumbnail,
  });

  factory RecordPhoto.fromJson(Map<String, dynamic> json) => RecordPhoto(
        path: json['path'] as String,
        thumbnail: json['thumbnail'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'path': path,
        'thumbnail': thumbnail,
      };
} 