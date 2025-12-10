/// Modelo que representa o progresso e conquistas do usuário no Tapioca Trips
class UserProgress {
  final String name;
  final String? avatarUrl;
  final int level;
  final int currentXP;
  final int xpToNextLevel;
  final int placesVisited;
  final int experiencesCompleted;
  final int totalXP;
  final List<Achievement> achievements;
  final DateTime memberSince;

  UserProgress({
    required this.name,
    this.avatarUrl,
    required this.level,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.placesVisited,
    required this.experiencesCompleted,
    required this.totalXP,
    required this.achievements,
    required this.memberSince,
  });

  /// Calcula o progresso percentual para o próximo nível
  double get progressPercentage {
    return currentXP / xpToNextLevel;
  }

  /// Retorna o XP restante para o próximo nível
  int get xpRemaining {
    return xpToNextLevel - currentXP;
  }

  /// Cria um usuário mock para desenvolvimento
  factory UserProgress.mock() {
    return UserProgress(
      name: "José Júnior",
      avatarUrl: "assets/images/avatar_traveler.png",
      level: 3,
      currentXP: 720,
      xpToNextLevel: 1000,
      placesVisited: 18,
      experiencesCompleted: 7,
      totalXP: 2720,
      memberSince: DateTime(2024, 1, 15),
      achievements: [
        Achievement(
          id: "explorer_delta",
          name: "Explorador Delta",
          description: "Visitou o Delta do Parnaíba",
          icon: "🏝️",
          xpReward: 100,
          unlockedAt: DateTime(2024, 2, 10),
          category: "Natureza",
        ),
        Achievement(
          id: "nature_friend",
          name: "Amigo da Natureza",
          description: "5 locais sustentáveis visitados",
          icon: "🌿",
          xpReward: 150,
          unlockedAt: DateTime(2024, 3, 5),
          category: "Sustentável",
        ),
        Achievement(
          id: "culture_lover",
          name: "Amante da Cultura",
          description: "Visitou 10 pontos culturais",
          icon: "🎭",
          xpReward: 200,
          unlockedAt: DateTime(2024, 2, 28),
          category: "Cultural",
        ),
        Achievement(
          id: "food_explorer",
          name: "Explorador Gastronômico",
          description: "Experimentou 5 pratos típicos",
          icon: "🍲",
          xpReward: 120,
          unlockedAt: DateTime(2024, 3, 12),
          category: "Gastronomia",
        ),
        Achievement(
          id: "first_trip",
          name: "Primeira Aventura",
          description: "Completou sua primeira viagem",
          icon: "🎒",
          xpReward: 50,
          unlockedAt: DateTime(2024, 1, 20),
          category: "Geral",
        ),
      ],
    );
  }
}

/// Modelo de conquista/medalha do usuário
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final DateTime unlockedAt;
  final String category;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.unlockedAt,
    required this.category,
  });

  /// Retorna a cor da categoria da conquista
  String get categoryColor {
    switch (category) {
      case 'Cultural':
        return 'culturalOrange';
      case 'Natureza':
        return 'natureGreen';
      case 'Gastronomia':
        return 'foodRed';
      case 'Sustentável':
        return 'sustainableGreen';
      default:
        return 'generalBlue';
    }
  }
}