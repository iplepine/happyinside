import '../models/challenge_progress.dart';

class ChallengeExploreItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final int participants;
  final String emoji;

  ChallengeExploreItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.participants,
    required this.emoji,
  });
}

class GetAvailableChallengesUseCase {
  /// 현재 진행 중인 챌린지를 제외한 사용 가능한 챌린지 목록을 반환합니다.
  List<ChallengeExploreItem> call(List<ChallengeProgress> activeChallenges) {
    final allChallenges = [
      ChallengeExploreItem(
        id: '1',
        title: '매일 감정 기록하기',
        description: '30일 동안 매일 감정을 기록하는 챌린지',
        category: '감정 관리',
        duration: '30일',
        difficulty: '쉬움',
        participants: 1250,
        emoji: '📝',
      ),
      ChallengeExploreItem(
        id: '2',
        title: '감사 일기 쓰기',
        description: '매일 감사한 일 3가지를 기록하기',
        category: '습관 형성',
        duration: '21일',
        difficulty: '보통',
        participants: 890,
        emoji: '🙏',
      ),
      ChallengeExploreItem(
        id: '3',
        title: '긍정적 사고 연습',
        description: '부정적인 상황에서 긍정적 관점 찾기',
        category: '자기계발',
        duration: '14일',
        difficulty: '어려움',
        participants: 567,
        emoji: '✨',
      ),
      ChallengeExploreItem(
        id: '4',
        title: '스트레스 해소 루틴',
        description: '매일 10분 명상으로 스트레스 관리하기',
        category: '건강',
        duration: '21일',
        difficulty: '보통',
        participants: 1200,
        emoji: '🧘‍♀️',
      ),
      ChallengeExploreItem(
        id: '5',
        title: '친구와 연락하기',
        description: '주 3회 이상 친구와 연락하고 대화하기',
        category: '관계',
        duration: '30일',
        difficulty: '쉬움',
        participants: 750,
        emoji: '💬',
      ),
      ChallengeExploreItem(
        id: '6',
        title: '독서 습관 만들기',
        description: '매일 30분씩 책 읽기',
        category: '자기계발',
        duration: '21일',
        difficulty: '보통',
        participants: 680,
        emoji: '📚',
      ),
      ChallengeExploreItem(
        id: '7',
        title: '운동 습관 만들기',
        description: '주 3회 이상 운동하기',
        category: '건강',
        duration: '30일',
        difficulty: '보통',
        participants: 950,
        emoji: '💪',
      ),
      ChallengeExploreItem(
        id: '8',
        title: '창의력 발달',
        description: '매일 새로운 아이디어 생각해보기',
        category: '자기계발',
        duration: '14일',
        difficulty: '어려움',
        participants: 320,
        emoji: '💡',
      ),
      ChallengeExploreItem(
        id: '9',
        title: '시간 관리 연습',
        description: '매일 할 일을 계획하고 실행하기',
        category: '습관 형성',
        duration: '21일',
        difficulty: '보통',
        participants: 450,
        emoji: '⏰',
      ),
      ChallengeExploreItem(
        id: '10',
        title: '감정 표현 연습',
        description: '매일 감정을 자유롭게 표현해보기',
        category: '감정 관리',
        duration: '14일',
        difficulty: '보통',
        participants: 380,
        emoji: '😊',
      ),
    ];

    // 현재 진행 중인 챌린지의 제목들을 추출
    final activeTitles = activeChallenges.map((c) => c.title).toList();
    
    // 진행 중인 챌린지를 제외한 목록 반환
    return allChallenges.where((challenge) => 
      !activeTitles.contains(challenge.title)
    ).toList();
  }
} 