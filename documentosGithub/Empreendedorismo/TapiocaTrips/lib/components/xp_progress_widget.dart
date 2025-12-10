import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../utils/theme.dart';

/// Widget de barra de progresso de XP com informações de nível
class XPProgressWidget extends StatelessWidget {
  final UserProgress userProgress;
  final bool showDetails;
  final bool compact;

  const XPProgressWidget({
    super.key,
    required this.userProgress,
    this.showDetails = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactView();
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.sustainableGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com nível e conquistas
          _buildHeader(),
          
          const SizedBox(height: 16),
          
          // Barra de progresso
          _buildProgressBar(),
          
          // Detalhes (se habilitado)
          if (showDetails) _buildDetails(),
        ],
      ),
    );
  }

  /// Visualização compacta
  Widget _buildCompactView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.sustainableGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.sustainableGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Nível
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.sustainableGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Nível ${userProgress.currentLevel}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Barra de progresso compacta
          Expanded(
            child: Stack(
              children: [
                // Fundo da barra
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Progresso
                Container(
                  height: 6,
                  width: MediaQuery.of(context).size.width * userProgress.levelProgress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.culturalOrange,
                        AppTheme.sustainableGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // XP
          Text(
            '${userProgress.xpInCurrentLevel}/${userProgress.xpForNextLevel}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.sustainableGreen,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o cabeçalho
  Widget _buildHeader() {
    return Row(
      children: [
        // Badge de nível
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.sustainableGreen,
                AppTheme.sustainableGreen.withOpacity(0.8),
            ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                'Nível ${userProgress.currentLevel}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Conquistas
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.culturalOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.culturalOrange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_rounded, 
                  color: AppTheme.culturalOrange, size: 16),
              const SizedBox(width: 6),
              Text(
                '${userProgress.achievementsUnlocked}/${userProgress.totalAchievements}',
                style: const TextStyle(
                  color: AppTheme.culturalOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói a barra de progresso
  Widget _buildProgressBar() {
    return Column(
      children: [
        // Barra
        Stack(
          children: [
            // Fundo da barra
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Progresso
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              height: 12,
              width: MediaQuery.of(context).size.width * userProgress.levelProgress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.culturalOrange,
                    AppTheme.sustainableGreen,
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sustainableGreen.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Informações de XP
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${userProgress.xpInCurrentLevel} XP',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${userProgress.xpForNextLevel} XP',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói os detalhes
  Widget _buildDetails() {
    return Column(
      children: [
        const SizedBox(height: 12),
        
        // Próximo nível
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.arrow_upward_rounded, 
                  color: Colors.blue, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Próximo nível: ${userProgress.currentLevel + 1}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${userProgress.totalXP} XP total',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Progresso por categoria
        _buildCategoryProgress(),
      ],
    );
  }

  /// Constrói progresso por categoria
  Widget _buildCategoryProgress() {
    final categories = AchievementCategory.values;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progresso por Categoria:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: categories.map((category) {
            final progress = userProgress.getCategoryProgress(category);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    size: 12,
                    color: _getCategoryColor(category),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: _getCategoryColor(category),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
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
    switch (category) {
      case AchievementCategory.exploration:
        return Icons.explore_rounded;
      case AchievementCategory.narrative:
        return Icons.record_voice_over_rounded;
      case AchievementCategory.social:
        return Icons.people_rounded;
      case AchievementCategory.collection:
        return Icons.collections_rounded;
      case AchievementCategory.sustainability:
        return Icons.eco_rounded;
      case AchievementCategory.special:
        return Icons.stars_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}