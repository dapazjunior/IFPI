/// Modelo que representa uma conquista/achievement no sistema de gamificação
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon; // Emoji ou nome do ícone
  final int xpReward;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final bool unlocked;
  final DateTime? unlockDate;
  final int progress; // Progresso atual (0 a targetValue)
  final int targetValue; // Valor necessário para desbloquear
  final List<String> unlockConditions; // Condições para desbloquear

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.category,
    required this.rarity,
    this.unlocked = false,
    this.unlockDate,
    this.progress = 0,
    this.targetValue = 1,
    this.unlockConditions = const [],
  });

  /// Cria uma Achievement a partir de JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🏆',
      xpReward: json['xpReward'] ?? 0,
      category: AchievementCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => AchievementCategory.exploration,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      unlocked: json['unlocked'] ?? false,
      unlockDate: json['unlockDate'] != null 
          ? DateTime.parse(json['unlockDate'])
          : null,
      progress: json['progress'] ?? 0,
      targetValue: json['targetValue'] ?? 1,
      unlockConditions: List<String>.from(json['unlockConditions'] ?? []),
    );
  }

  /// Converte Achievement para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'category': category.name,
      'rarity': rarity.name,
      'unlocked': unlocked,
      'unlockDate': unlockDate?.toIso8601String(),
      'progress': progress,
      'targetValue': targetValue,
      'unlockConditions': unlockConditions,
    };
  }

  /// Cria uma cópia da achievement com valores atualizados
  Achievement copyWith({
    bool? unlocked,
    DateTime? unlockDate,
    int? progress,
    int? targetValue,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      xpReward: xpReward,
      category: category,
      rarity: rarity,
      unlocked: unlocked ?? this.unlocked,
      unlockDate: unlockDate ?? this.unlockDate,
      progress: progress ?? this.progress,
      targetValue: targetValue ?? this.targetValue,
      unlockConditions: unlockConditions,
    );
  }

  /// Incrementa o progresso da conquista
  Achievement incrementProgress([int amount = 1]) {
    final newProgress = progress + amount;
    final shouldUnlock = newProgress >= targetValue && !unlocked;
    
    return copyWith(
      progress: newProgress.clamp(0, targetValue),
      unlocked: shouldUnlock ? true : unlocked,
      unlockDate: shouldUnlock ? DateTime.now() : unlockDate,
    );
  }

  /// Retorna o progresso como porcentagem (0.0 a 1.0)
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (progress / targetValue).clamp(0.0, 1.0);
  }

  /// Verifica se a conquista pode ser desbloqueada
  bool get canUnlock {
    return !unlocked && progress >= targetValue;
  }

  /// Retorna descrição do progresso
  String get progressDescription {
    if (unlocked) return 'Conquistada!';
    return '$progress/$targetValue';
  }

  /// Retorna cor baseada na raridade
  Color get rarityColor {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  String toString() {
    return 'Achievement($title: $progress/$targetValue - ${unlocked ? "Desbloqueada" : "Bloqueada"})';
  }
}

/// Categorias de conquistas
enum AchievementCategory {
  exploration,    // Exploração de rotas e POIs
  narrative,      // Narrativas e áudios
  social,         // Interações sociais
  collection,     // Coleta e favoritos
  sustainability, // Sustentabilidade
  special,        // Conquistas especiais
}

/// Raridade das conquistas
enum AchievementRarity {
  common,     // Comum - Cinza
  rare,       // Rara - Azul
  epic,       // Épica - Roxo
  legendary,  // Lendária - Laranja
}

/// Estatísticas de progresso do usuário
class UserProgress {
  final int totalXP;
  final int currentLevel;
  final int achievementsUnlocked;
  final int totalAchievements;
  final Map<AchievementCategory, int> categoryProgress;
  final DateTime lastUpdate;

  const UserProgress({
    required this.totalXP,
    required this.currentLevel,
    required this.achievementsUnlocked,
    required this.totalAchievements,
    required this.categoryProgress,
    required this.lastUpdate,
  });

  /// Cria UserProgress a partir de JSON
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final categoryProgress = <AchievementCategory, int>{};
    if (json['categoryProgress'] != null) {
      (json['categoryProgress'] as Map).forEach((key, value) {
        final category = AchievementCategory.values.firstWhere(
          (e) => e.name == key,
          orElse: () => AchievementCategory.exploration,
        );
        categoryProgress[category] = value;
      });
    }

    return UserProgress(
      totalXP: json['totalXP'] ?? 0,
      currentLevel: json['currentLevel'] ?? 1,
      achievementsUnlocked: json['achievementsUnlocked'] ?? 0,
      totalAchievements: json['totalAchievements'] ?? 0,
      categoryProgress: categoryProgress,
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.parse(json['lastUpdate'])
          : DateTime.now(),
    );
  }

  /// Converte UserProgress para JSON
  Map<String, dynamic> toJson() {
    final categoryProgressJson = <String, int>{};
    categoryProgress.forEach((key, value) {
      categoryProgressJson[key.name] = value;
    });

    return {
      'totalXP': totalXP,
      'currentLevel': currentLevel,
      'achievementsUnlocked': achievementsUnlocked,
      'totalAchievements': totalAchievements,
      'categoryProgress': categoryProgressJson,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  /// Calcula o XP necessário para o próximo nível
  int get xpForNextLevel {
    return currentLevel * 500;
  }

  /// Calcula o XP atual neste nível
  int get xpInCurrentLevel {
    if (currentLevel == 1) return totalXP;
    final previousLevelXP = _calculateTotalXPForLevel(currentLevel - 1);
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
      xp += i * 500;
    }
    return xp;
  }

  /// Progresso por categoria
  double getCategoryProgress(AchievementCategory category) {
    final unlocked = categoryProgress[category] ?? 0;
    final total = _getTotalAchievementsByCategory(category);
    return total > 0 ? unlocked / total : 0.0;
  }

  /// Retorna total de conquistas por categoria
  int _getTotalAchievementsByCategory(AchievementCategory category) {
    // Valores padrão - em implementação real viria do serviço
    final totals = {
      AchievementCategory.exploration: 5,
      AchievementCategory.narrative: 4,
      AchievementCategory.social: 3,
      AchievementCategory.collection: 3,
      AchievementCategory.sustainability: 4,
      AchievementCategory.special: 2,
    };
    return totals[category] ?? 0;
  }

  @override
  String toString() {
    return 'UserProgress(Level $currentLevel, XP: $totalXP, Conquistas: $achievementsUnlocked/$totalAchievements)';
  }
}