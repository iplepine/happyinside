class ChallengeProgress {
  final String id;
  final String title;
  final String description;
  final double progress; // 0.0 ~ 1.0
  final String todayTask;
  final DateTime startDate;
  final DateTime? endDate;

  ChallengeProgress({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.todayTask,
    required this.startDate,
    this.endDate,
  });
} 