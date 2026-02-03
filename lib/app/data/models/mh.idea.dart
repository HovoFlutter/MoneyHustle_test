enum MHIdeaCategory {
  onlineWork('Online Work'),
  offlineGigs('Offline Gigs'),
  hobbyIncome('Hobby Income'),
  seasonal('Seasonal'),
  skillsFreelance('Skills & Freelance'),
  sellingReselling('Selling & Reselling');

  final String label;
  const MHIdeaCategory(this.label);
}

enum MHInvestmentType {
  none('No Investment'),
  upTo100('Up to \$100'),
  equipmentRequired('Equipment Required');

  final String label;
  const MHInvestmentType(this.label);
}

enum MHIdeaStatus {
  saved,
  inProgress,
  completed,
}

class MHIdea {
  final String id;
  final String title;
  final String preview;
  final String content;
  final List<String> steps;
  final List<String> tips;
  final String disclaimer;
  final MHIdeaCategory category;
  final MHInvestmentType investmentType;
  final DateTime createdAt;
  final int readMinutes;

  const MHIdea({
    required this.id,
    required this.title,
    required this.preview,
    required this.content,
    required this.steps,
    required this.tips,
    required this.disclaimer,
    required this.category,
    required this.investmentType,
    required this.createdAt,
    required this.readMinutes,
  });

  MHIdea copyWith({
    String? id,
    String? title,
    String? preview,
    String? content,
    List<String>? steps,
    List<String>? tips,
    String? disclaimer,
    MHIdeaCategory? category,
    MHInvestmentType? investmentType,
    DateTime? createdAt,
    int? readMinutes,
  }) {
    return MHIdea(
      id: id ?? this.id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      content: content ?? this.content,
      steps: steps ?? this.steps,
      tips: tips ?? this.tips,
      disclaimer: disclaimer ?? this.disclaimer,
      category: category ?? this.category,
      investmentType: investmentType ?? this.investmentType,
      createdAt: createdAt ?? this.createdAt,
      readMinutes: readMinutes ?? this.readMinutes,
    );
  }
}

class MHSavedIdea {
  final String ideaId;
  final MHIdeaStatus status;
  final int progress;
  final List<bool> stepsCompleted;
  final DateTime savedAt;

  const MHSavedIdea({
    required this.ideaId,
    required this.status,
    this.progress = 0,
    this.stepsCompleted = const [],
    required this.savedAt,
  });

  MHSavedIdea copyWith({
    String? ideaId,
    MHIdeaStatus? status,
    int? progress,
    List<bool>? stepsCompleted,
    DateTime? savedAt,
  }) {
    return MHSavedIdea(
      ideaId: ideaId ?? this.ideaId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ideaId': ideaId,
      'status': status.index,
      'progress': progress,
      'stepsCompleted': stepsCompleted,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory MHSavedIdea.fromJson(Map<String, dynamic> json) {
    return MHSavedIdea(
      ideaId: json['ideaId'] as String,
      status: MHIdeaStatus.values[json['status'] as int],
      progress: json['progress'] as int? ?? 0,
      stepsCompleted: (json['stepsCompleted'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          [],
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
