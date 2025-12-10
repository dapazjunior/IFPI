/// Modelo que representa uma conquista/medalha no sistema de gamificação
class Badge {
  final String id;
  final String title;
  final String description;
  final String icon; // Emoji ou nome do ícone
  final int targetValue; // Valor necessário para desbloquear
  final int currentValue; // Progresso atual
  final bool unlocked;
  final DateTime? unlockDate;
  final BadgeType type;

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    required this.type,
    this.currentValue = 0,
    this.unlocked = false,
    this.unlockDate,
  });

  /// Cria uma Badge a partir de JSON
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🏆',
      targetValue: json['targetValue'] ?? 1,
      currentValue: json['currentValue'] ?? 0,
      unlocked: json['unlocked'] ?? false,
      unlockDate: json['unlockDate'] != null 
          ? DateTime.parse(json['unlockDate'])
          : null,
      type: BadgeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BadgeType.exploration,
      ),
    );
  }

  /// Converte Badge para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unlocked': unlocked,
      'unlockDate': unlockDate?.toIso8601String(),
      'type': type.name,
    };
  }

  /// Cria uma cópia da badge com valores atualizados
  Badge copyWith({
    int? currentValue,
    bool? unlocked,
    DateTime? unlockDate,
  }) {
    return Badge(
      id: id,
      title: title,
      description: description,
      icon: icon,
      targetValue: targetValue,
      type: type,
      currentValue: currentValue ?? this.currentValue,
      unlocked: unlocked ?? this.unlocked,
      unlockDate: unlockDate ?? this.unlockDate,
    );
  }

  /// Retorna o progresso como porcentagem (0.0 a 1.0)
  double get progress {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  /// Verifica se a badge pode ser desbloqueada
  bool get canUnlock {
    return !unlocked && currentValue >= targetValue;
  }

  @override
  String toString() {
    return 'Badge($title: $currentValue/$targetValue - ${unlocked ? "Desbloqueada" : "Bloqueada"})';
  }
}

/// Tipos de badges disponíveis no sistema
enum BadgeType {
  exploration,    // Exploração de rotas
  social,         // Interações sociais
  completion,     // Conclusões
  sharing,        // Compartilhamentos
  special,        // Conquistas especiais
}

/// Estatísticas do usuário para gamificação
class UserStats {
  final int totalXP;
  final int level;
  final int routesCompleted;
  final int reviewsWritten;
  final int sharesDone;
  final int badgesUnlocked;
  final DateTime lastActivity;

  const UserStats({
    required this.totalXP,
    required this.level,
    required this.routesCompleted,
    required this.reviewsWritten,
    required this.sharesDone,
    required this.badgesUnlocked,
    required this.lastActivity,
  });

  /// Cria UserStats a partir de JSON
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalXP: json['totalXP'] ?? 0,
      level: json['level'] ?? 1,
      routesCompleted: json['routesCompleted'] ?? 0,
      reviewsWritten: json['reviewsWritten'] ?? 0,
      sharesDone: json['sharesDone'] ?? 0,
      badgesUnlocked: json['badgesUnlocked'] ?? 0,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'])
          : DateTime.now(),
    );
  }

  /// Converte UserStats para JSON
  Map<String, dynamic> toJson() {
    return {
      'totalXP': totalXP,
      'level': level,
      'routesCompleted': routesCompleted,
      'reviewsWritten': reviewsWritten,
      'sharesDone': sharesDone,
      'badgesUnlocked': badgesUnlocked,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  /// Cria uma cópia com valores atualizados
  UserStats copyWith({
    int? totalXP,
    int? level,
    int? routesCompleted,
    int? reviewsWritten,
    int? sharesDone,
    int? badgesUnlocked,
    DateTime? lastActivity,
  }) {
    return UserStats(
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      routesCompleted: routesCompleted ?? this.routesCompleted,
      reviewsWritten: reviewsWritten ?? this.reviewsWritten,
      sharesDone: sharesDone ?? this.sharesDone,
      badgesUnlocked: badgesUnlocked ?? this.badgesUnlocked,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  /// Calcula o XP necessário para o próximo nível
  int get xpForNextLevel {
    return level * 200;
  }

  /// Calcula o XP atual neste nível
  int get xpInCurrentLevel {
    if (level == 1) return totalXP;
    final previousLevelXP = _calculateTotalXPForLevel(level - 1);
    return totalXP - previousLevelXP;
  }

  /// Progresso para o próximo nível (0.0 a 1.0)
  double get levelProgress {
    return (xpInCurrentLevel / xpForNextLevel).clamp(0.0, 1.0);
  }

  /// Calcula o XP total necessário para alcançar um nível
  int _calculateTotalXPForLevel(int targetLevel) {
    int xp = 0;
    for (int i = 1; i < targetLevel; i++) {
      xp += i * 200;
    }
    return xp;
  }

  @override
  String toString() {
    return 'UserStats(Level $level, XP: $totalXP, Rotas: $routesCompleted, Reviews: $reviewsWritten)';
  }
}