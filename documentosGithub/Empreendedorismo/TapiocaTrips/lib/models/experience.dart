/// Modelo que representa uma experiência interativa no Tapioca Trips
class Experience {
  final String id;
  final String title;
  final String category;
  final String location;
  final String description;
  final String detailedDescription;
  final int xpReward;
  final String? imageUrl;
  final List<ExperienceStep> steps;
  final Duration estimatedDuration;
  final String difficulty;
  final bool isFeatured;
  final double rating;
  final int completionsCount;
  final List<String> tags;

  Experience({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.detailedDescription,
    required this.xpReward,
    this.imageUrl,
    required this.steps,
    required this.estimatedDuration,
    required this.difficulty,
    this.isFeatured = false,
    this.rating = 0.0,
    this.completionsCount = 0,
    this.tags = const [],
  });

  /// Verifica se a experiência está completa
  bool get isComplete {
    return steps.every((step) => step.isCompleted);
  }

  /// Calcula o progresso da experiência (0.0 a 1.0)
  double get progress {
    if (steps.isEmpty) return 0.0;
    final completedSteps = steps.where((step) => step.isCompleted).length;
    return completedSteps / steps.length;
  }

  /// Retorna o número de etapas completadas
  int get completedStepsCount {
    return steps.where((step) => step.isCompleted).length;
  }

  /// Retorna a cor baseada na categoria
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

  /// Retorna o ícone baseado na categoria
  String get categoryIcon {
    switch (category) {
      case 'Cultural':
        return '🎭';
      case 'Natureza':
        return '🌿';
      case 'Gastronomia':
        return '🍲';
      case 'Sustentável':
        return '♻️';
      default:
        return '🎯';
    }
  }

  /// Cria lista mock de experiências para desenvolvimento
  static List<Experience> mockExperiences() {
    return [
      Experience(
        id: "exp_001",
        title: "Trilha do Delta Encantado",
        category: "Natureza",
        location: "Parnaíba - PI",
        description: "Descubra o Delta do Parnaíba através de uma trilha ecológica interativa.",
        detailedDescription: "Uma jornada incrível pelos labirintos naturais do único delta em mar aberto das Américas. Conheça a biodiversidade local, aviste aves migratórias e aprenda sobre a importância da preservação deste ecossistema único.",
        xpReward: 150,
        imageUrl: "assets/images/delta_trilha.jpg",
        estimatedDuration: const Duration(hours: 3),
        difficulty: "Moderado",
        isFeatured: true,
        rating: 4.8,
        completionsCount: 342,
        tags: ["Trilha", "Ecologia", "Passeio de Barco"],
        steps: [
          ExperienceStep(
            id: "step_1",
            title: "Chegar ao ponto de partida",
            description: "Encontre o centro de visitantes no Porto dos Tatus",
            isCompleted: false,
            order: 1,
          ),
          ExperienceStep(
            id: "step_2",
            title: "Avistar as garças brancas",
            description: "Observe as garças no manguezal durante o passeio",
            isCompleted: false,
            order: 2,
          ),
          ExperienceStep(
            id: "step_3",
            title: "Registrar uma foto da paisagem",
            description: "Capture a vista única do encontro do rio com o mar",
            isCompleted: false,
            order: 3,
          ),
          ExperienceStep(
            id: "step_4",
            title: "Finalizar trilha no mirante",
            description: "Aprecie a vista panorâmica do mirante principal",
            isCompleted: false,
            order: 4,
          ),
        ],
      ),
      Experience(
        id: "exp_002",
        title: "Rota Cultural de Teresina",
        category: "Cultural",
        location: "Teresina - PI",
        description: "Explore o centro histórico e a cultura piauiense em uma jornada pelo tempo.",
        detailedDescription: "Um passeio pela memória da capital do Piauí. Conheça a arquitetura colonial, museus importantes e a rica história da primeira capital planejada do Brasil.",
        xpReward: 120,
        imageUrl: "assets/images/teresina_cultural.jpg",
        estimatedDuration: const Duration(hours: 4),
        difficulty: "Fácil",
        isFeatured: false,
        rating: 4.6,
        completionsCount: 215,
        tags: ["História", "Arquitetura", "Museus"],
        steps: [
          ExperienceStep(
            id: "step_1",
            title: "Visitar o Porto das Barcas",
            description: "Explore o centro histórico e comércio local",
            isCompleted: false,
            order: 1,
          ),
          ExperienceStep(
            id: "step_2",
            title: "Conhecer o Museu do Piauí",
            description: "Aprenda sobre a história e cultura piauiense",
            isCompleted: false,
            order: 2,
          ),
          ExperienceStep(
            id: "step_3",
            title: "Fotografar a Ponte Metálica",
            description: "Registre este marco histórico da cidade",
            isCompleted: false,
            order: 3,
          ),
          ExperienceStep(
            id: "step_4",
            title: "Provar comida típica",
            description: "Experimente um prato da culinária local",
            isCompleted: false,
            order: 4,
          ),
        ],
      ),
      Experience(
        id: "exp_003",
        title: "Circuito Sustentável da Chapada",
        category: "Sustentável",
        location: "Pedro II - PI",
        description: "Conheça iniciativas de turismo sustentável na região da chapada.",
        detailedDescription: "Uma experiência focada em sustentabilidade e conservação. Visite projetos comunitários, aprenda sobre agricultura familiar e participe de práticas ecológicas na belíssima região da chapada piauiense.",
        xpReward: 180,
        imageUrl: "assets/images/chapada_sustentavel.jpg",
        estimatedDuration: const Duration(hours: 5),
        difficulty: "Moderado",
        isFeatured: true,
        rating: 4.9,
        completionsCount: 128,
        tags: ["Sustentabilidade", "Comunidade", "Ecoturismo"],
        steps: [
          ExperienceStep(
            id: "step_1",
            title: "Visitar cooperativa local",
            description: "Conheça o trabalho da cooperativa de artesanato",
            isCompleted: false,
            order: 1,
          ),
          ExperienceStep(
            id: "step_2",
            title: "Participar de oficina sustentável",
            description: "Aprenda técnicas de reciclagem e reutilização",
            isCompleted: false,
            order: 2,
          ),
          ExperienceStep(
            id: "step_3",
            title: "Plantar uma árvore nativa",
            description: "Contribua com o reflorestamento local",
            isCompleted: false,
            order: 3,
          ),
          ExperienceStep(
            id: "step_4",
            title: "Documentar aprendizado",
            description: "Registre suas descobertas no diário de viagem",
            isCompleted: false,
            order: 4,
          ),
        ],
      ),
      Experience(
        id: "exp_004",
        title: "Sabores do Piauí",
        category: "Gastronomia",
        location: "Vários locais - PI",
        description: "Uma jornada gastronômica pelos sabores autênticos do Piauí.",
        detailedDescription: "Descubra a rica culinária piauiense através de seus pratos típicos, ingredientes locais e tradições culinárias. Uma verdadeira festa para o paladar!",
        xpReward: 100,
        imageUrl: "assets/images/sabores_piaui.jpg",
        estimatedDuration: const Duration(hours: 6),
        difficulty: "Fácil",
        isFeatured: false,
        rating: 4.7,
        completionsCount: 389,
        tags: ["Culinária", "Tradição", "Mercados"],
        steps: [
          ExperienceStep(
            id: "step_1",
            title: "Provar a Maria Isabel",
            description: "Experimente o prato típico de arroz com carne seca",
            isCompleted: false,
            order: 1,
          ),
          ExperienceStep(
            id: "step_2",
            title: "Visitar feira livre",
            description: "Conheça ingredientes locais em uma feira tradicional",
            isCompleted: false,
            order: 2,
          ),
          ExperienceStep(
            id: "step_3",
            title: "Aprender receita regional",
            description: "Anote uma receita típica com um morador local",
            isCompleted: false,
            order: 3,
          ),
          ExperienceStep(
            id: "step_4",
            title: "Documentar experiência",
            description: "Registre suas descobertas gastronômicas",
            isCompleted: false,
            order: 4,
          ),
        ],
      ),
    ];
  }
}

/// Modelo de etapa individual de uma experiência
class ExperienceStep {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int order;

  ExperienceStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.order,
  });

  /// Cria uma cópia com o estado de completude alterado
  ExperienceStep copyWith({bool? isCompleted}) {
    return ExperienceStep(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order,
    );
  }
}