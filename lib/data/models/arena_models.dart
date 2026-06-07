class ArenaRoom {
  final String id;
  final String code;
  final String host;
  final List<ArenaParticipant> participants;
  final String status;
  final List<ArenaQuestion> questions;
  final DateTime? startedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArenaRoom({
    required this.id,
    required this.code,
    required this.host,
    required this.participants,
    required this.status,
    required this.questions,
    this.startedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ArenaRoom.fromJson(Map<String, dynamic> json) {
    final rawParticipants = json['participants'];
    final participants = <ArenaParticipant>[];
    if (rawParticipants is List) {
      for (final item in rawParticipants) {
        if (item is Map<String, dynamic>) {
          participants.add(ArenaParticipant.fromJson(item));
        } else if (item is Map) {
          participants
              .add(ArenaParticipant.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final rawQuestions = json['questions'];
    final questions = <ArenaQuestion>[];
    if (rawQuestions is List) {
      for (var i = 0; i < rawQuestions.length; i++) {
        final item = rawQuestions[i];
        if (item is Map<String, dynamic>) {
          questions.add(ArenaQuestion.fromJson(item, i));
        } else if (item is Map) {
          questions
              .add(ArenaQuestion.fromJson(Map<String, dynamic>.from(item), i));
        }
      }
    }

    return ArenaRoom(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      host: json['host']?.toString() ?? '',
      participants: participants,
      status: json['status']?.toString() ?? 'waiting',
      questions: questions,
      startedAt: _parseDateTime(json['startedAt']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  ArenaParticipant? participantForUser(String userId) {
    for (final participant in participants) {
      if (participant.user.id == userId) {
        return participant;
      }
    }
    return null;
  }

  bool get hasQuestions => questions.isNotEmpty;
}

class ArenaParticipant {
  final ArenaParticipantUser user;
  final bool ready;
  final DateTime? joinedAt;
  final List<ArenaAnswer> answers;
  final int correctCount;
  final int totalTime;

  ArenaParticipant({
    required this.user,
    required this.ready,
    this.joinedAt,
    required this.answers,
    required this.correctCount,
    required this.totalTime,
  });

  factory ArenaParticipant.fromJson(Map<String, dynamic> json) {
    return ArenaParticipant(
      user: ArenaParticipantUser.fromJson(json['user']),
      ready: json['ready'] == true,
      joinedAt: ArenaRoom._parseDateTime(json['joinedAt']),
      answers: _parseAnswers(json['answers']),
      correctCount: _parseInt(json['correctCount']),
      totalTime: _parseInt(json['totalTime']),
    );
  }

  static List<ArenaAnswer> _parseAnswers(dynamic raw) {
    final result = <ArenaAnswer>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          result.add(ArenaAnswer.fromJson(item));
        } else if (item is Map) {
          result.add(ArenaAnswer.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
    return result;
  }

  static int _parseInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw) ?? 0;
    return 0;
  }
}

class ArenaParticipantUser {
  final String id;
  final String? username;
  final String? email;

  ArenaParticipantUser({
    required this.id,
    this.username,
    this.email,
  });

  factory ArenaParticipantUser.fromJson(dynamic raw) {
    if (raw is String) {
      return ArenaParticipantUser(id: raw);
    }
    if (raw is Map<String, dynamic>) {
      return ArenaParticipantUser(
        id: raw['_id']?.toString() ?? raw['id']?.toString() ?? '',
        username: raw['username']?.toString(),
        email: raw['email']?.toString(),
      );
    }
    return ArenaParticipantUser(id: raw?.toString() ?? '');
  }

  String get displayName {
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    if (email != null && email!.isNotEmpty) {
      return email!.split('@').first;
    }
    return id.isEmpty ? 'Người chơi' : id;
  }
}

class ArenaQuestion {
  final int index;
  final String text;
  final List<String> options;
  final Map<String, dynamic> raw;

  ArenaQuestion({
    required this.index,
    required this.text,
    required this.options,
    required this.raw,
  });

  factory ArenaQuestion.fromJson(Map<String, dynamic> json, int index) {
    final text = json['text']?.toString() ??
        json['question']?.toString() ??
        json['content']?.toString() ??
        json['title']?.toString() ??
        'Câu hỏi ${index + 1}';

    final rawOptions = json['options'] ?? json['choices'] ?? json['answers'];
    final options = <String>[];
    if (rawOptions is List) {
      for (final option in rawOptions) {
        options.add(option?.toString() ?? '');
      }
    }

    return ArenaQuestion(
      index: index,
      text: text,
      options: options.where((element) => element.isNotEmpty).toList(),
      raw: Map<String, dynamic>.from(json),
    );
  }
}

class ArenaAnswer {
  final int questionIndex;
  final String answer;
  final bool correct;
  final int duration;
  final DateTime? answeredAt;

  ArenaAnswer({
    required this.questionIndex,
    required this.answer,
    required this.correct,
    required this.duration,
    this.answeredAt,
  });

  factory ArenaAnswer.fromJson(Map<String, dynamic> json) {
    return ArenaAnswer(
      questionIndex: _parseInt(json['questionIndex']),
      answer: json['answer']?.toString() ?? '',
      correct: json['correct'] == true,
      duration: _parseInt(json['duration']),
      answeredAt: ArenaRoom._parseDateTime(json['answeredAt']),
    );
  }

  static int _parseInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw) ?? 0;
    return 0;
  }
}
