import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../services/gamification_service.dart';
import '../utils/theme.dart';

/// Tela de Conquistas - Mostra todas as conquistas e progresso do usuário
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Achievement> _achievements = [];
  UserProgress? _userProgress;
  AchievementCategory _selectedCategory = AchievementCategory.exploration;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  /// Carrega conquistas e progresso
  Future<void> _loadAchievements() async {
    await GamificationService.initialize();
    
    if (mounted) {
      setState(() {
        _achievements = _getAllAchievements();
        _userProgress = _getUserProgress();
        _isLoading = false;
      });
    }
  }

  /// Retorna todas as conquistas disponíveis
  List<Achievement> _getAllAchievements() {
    return [
      // Exploração
      Achievement(
        id: 'first_route',
        title: '🗺️ Primeira Jornada',
        description: 'Complete sua primeira rota no Tapioca Trips',
        icon: '🗺️',
        xpReward: 100,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.common,
        targetValue: 1,
      ),
      Achievement(
        id: 'explorer_tapioca',
        title: '🧭 Explorador Tapioca',
        description: 'Complete 3 rotas diferentes',
        icon: '🧭',
        xpReward: 150,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.rare,
        targetValue: 3,
      ),
      Achievement(
        id: 'route_master',
        title: '🏔️ Mestre de Rotas',
        description: 'Complete 10 rotas no total',
        icon: '🏔️',
        xpReward: 300,
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.epic,
        targetValue: 10,
      ),

      // Narrativas
      Achievement(
        id: 'first_story',
        title: '🎧 Primeira História',
        description: 'Ouça sua primeira narrativa completa',
        icon: '🎧',
        xpReward: 30,
        category: AchievementCategory.narrative,
        rarity: AchievementRarity.common,
        targetValue: 1,
      ),
      Achievement(
        id: 'story_collector',
        title: '📖 Coletor de Histórias',
        description: 'Ouça 10 narrativas diferentes',
        icon: '📖',
        xpReward: 150,
        category: AchievementCategory.narrative,
        rarity: AchievementRarity.rare,
        targetValue: 10,
      ),
      Achievement(
        id: 'narrative_master',
        title: '🏆 Mestre das Narrativas',
        description: 'Ouça todas as histórias de uma rota completa',
        icon: '🏆',
        xpReward: 200,
        category: AchievementCategory.narrative,
        rarity: AchievementRarity.epic,
        targetValue: 5,
      ),

      // Sustentabilidade
      Achievement(
        id: 'sustainable_tourist',
        title: '🌿 Turista Sustentável',
        description: 'Complete 3 rotas ecológicas',
        icon: '🌿',
        xpReward: 150,
        category: AchievementCategory.sustainability,
        rarity: AchievementRarity.rare,
        targetValue: 3,
      ),
      Achievement(
        id: 'eco_warrior',
        title: '♻️ Guerreiro Ecológico',
        description: 'Complete 5 rotas com foco em sustentabilidade',
        icon: '♻️',
        xpReward: 250,
        category: AchievementCategory.sustainability,
        rarity: AchievementRarity.epic,
        targetValue: 5,
      ),

      // Coleção
      Achievement(
        id: 'heart_tapioca',
        title: '❤️ Coração Tapioca',
        description: 'Favorite 5 destinos',
        icon: '❤️',
        xpReward: 50,
        category: AchievementCategory.collection,
        rarity: AchievementRarity.common,
        targetValue: 5,
      ),
      Achievement(
        id: 'treasure_hunter',
        title: '💎 Caçador de Tesouros',
        description: 'Favorite 15 destinos diferentes',
        icon: '💎',
        xpReward: 200,
        category: AchievementCategory.collection,
        rarity: AchievementRarity.rare,
        targetValue: 15,
      ),

      // Social
      Achievement(
        id: 'community_guide',
        title: '✍️ Guia da Comunidade',
        description: 'Escreva 3 avaliações para ajudar outros viajantes',
        icon: '✍️',
        xpReward: 100,
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        targetValue: 3,
      ),
      Achievement(
        id: 'tapioca_influencer',
        title: '📢 Influencer Tapioca',
        description: 'Compartilhe 5 rotas com amigos',
        icon: '📢',
        xpReward: 120,
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        targetValue: 5,
      ),

      // Especiais
      Achievement(
        id: 'tapioca_ambassador',
        title: '🥇 Embaixador Tapioca',
        description: 'Complete 10 rotas e compartilhe 10 rotas',
        icon: '🥇',
        xpReward: 500,
        category: AchievementCategory.special,
        rarity: AchievementRarity.legendary,
        targetValue: 10,
      ),
    ];
  }

  /// Retorna progresso do usuário (mock - em app real viria do serviço)
  UserProgress _getUserProgress() {
    return UserProgress(
      totalXP: 450,
      currentLevel: 2,
      achievementsUnlocked: 3,
      totalAchievements: _achievements.length,
      categoryProgress: {
        AchievementCategory.exploration: 1,
        AchievementCategory.narrative: 1,
        AchievementCategory.social: 0,
        AchievementCategory.collection: 1,
        AchievementCategory.sustainability: 0,
        AchievementCategory.special: 0,
      },
      lastUpdate: DateTime.now(),
    );
  }

  /// Constrói os filtros de categoria
  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: AchievementCategory.values.map((category) {
          return _buildFilterChip(category);
        }).toList(),
      ),
    );
  }

  /// Constrói chip de filtro
  Widget _buildFilterChip(AchievementCategory category) {
    final isSelected = _selectedCategory == category;
    final progress = _userProgress?.getCategoryProgress(category) ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getCategoryIcon(category), size: 16),
            const SizedBox(width: 6),
            Text(_getCategoryName(category)),
            const SizedBox(width: 4),
            Text(
              '(${(progress * 100).toInt()}%)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: _getCategoryColor(category).withOpacity(0.2),
        checkmarkColor: _getCategoryColor(category),
        labelStyle: TextStyle(
          color: isSelected ? _getCategoryColor(category) : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  /// Constrói a lista de conquistas
  Widget _buildAchievementsList() {
    final filteredAchievements = _achievements
        .where((achievement) => achievement.category == _selectedCategory)
        .toList();

    if (filteredAchievements.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAchievements.length,
        itemBuilder: (context, index) {
          return _buildAchievementCard(filteredAchievements[index]);
        },
      ),
    );
  }

  /// Constrói card de conquista
  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: achievement.unlocked ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: achievement.unlocked 
          ? achievement.rarityColor.withOpacity(0.1)
          : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ícone da conquista
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: achievement.unlocked 
                    ? achievement.rarityColor.withOpacity(0.2)
                    : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: achievement.unlocked 
                      ? achievement.rarityColor 
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Informações da conquista
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: achievement.unlocked 
                                ? Colors.black87 
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      // Badge de raridade
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: achievement.rarityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getRarityName(achievement.rarity),
                          style: TextStyle(
                            fontSize: 10,
                            color: achievement.rarityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: achievement.unlocked 
                          ? Colors.grey[700] 
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Barra de progresso e recompensa
                  Row(
                    children: [
                      // Barra de progresso
                      if (!achievement.unlocked) ...[
                        Expanded(
                          child: LinearProgressIndicator(
                            value: achievement.progressPercentage,
                            backgroundColor: Colors.grey[300],
                            color: achievement.rarityColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          achievement.progressDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Text(
                            'Conquistada!',
                            style: TextStyle(
                              fontSize: 12,
                              color: achievement.rarityColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(width: 12),
                      
                      // Recompensa de XP
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, 
                                size: 12, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '+${achievement.xpReward}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_rounded, 
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma conquista nesta categoria',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Continue explorando para desbloquear novas conquistas!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna nome da categoria
  String _getCategoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.exploration:
        return 'Exploração';
      case AchievementCategory.narrative:
        return 'Narrativas';
      case AchievementCategory.social:
        return 'Social';
      case AchievementCategory.collection:
        return 'Coleção';
      case AchievementCategory.sustainability:
        return 'Sustentabilidade';
      case AchievementCategory.special:
        return 'Especiais';
      default:
        return 'Geral';
    }
  }

  /// Retorna nome da raridade
  String _getRarityName(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return 'Comum';
      case AchievementRarity.rare:
        return 'Rara';
      case AchievementRarity.epic:
        return 'Épica';
      case AchievementRarity.legendary:
        return 'Lendária';
      default:
        return 'Comum';
    }
  }

  /// Retorna cor baseada na categoria
  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.exploration:
        return Colors.green;
      case AchievementCategory.narrative:
        return Colors.blue;
      case AchievementCategory.social:
        return Colors.purple;
      case AchievementCategory.collection:
        return Colors.orange;
      case AchievementCategory.sustainability:
        return AppTheme.sustainableGreen;
      case AchievementCategory.special:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Retorna ícone baseado na categoria
  IconData _getCategoryIcon(AchievementCategory category) {
    switch