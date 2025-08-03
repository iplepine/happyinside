class EmotionRecord {
  final String id;
  final int score; // 1-10
  final String emotion; // 감정 키워드
  final String emoji; // 이모지
  final DateTime recordedAt;
  final String? note;

  EmotionRecord({
    required this.id,
    required this.score,
    required this.emotion,
    required this.emoji,
    required this.recordedAt,
    this.note,
  });
} 