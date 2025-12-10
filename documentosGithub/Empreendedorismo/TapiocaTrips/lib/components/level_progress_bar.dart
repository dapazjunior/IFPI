import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../utils/theme.dart';

/// Barra de progresso personalizada para mostrar nível e XP do usuário
class LevelProgressBar extends StatelessWidget {
  final UserStats userStats;
  final bool showDetails;

  const LevelProgressBar({
    super.key,
    required this.userStats,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com nível atual
          Row(
            children: [
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
                child: Text(
                  'Nível ${userStats.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              if (showDetails)
                Text(
                  '${userStats.totalXP} XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.sustainableGreen,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Barra de progresso
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
                width: MediaQuery.of(context).size.width * userStats.levelProgress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.culturalOrange,
                      AppTheme.culturalOrange.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Informações de progresso
          if (showDetails)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userStats.xpInCurrentLevel} XP',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${userStats.xpForNextLevel} XP para o próximo nível',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          
          // Próximo nível
          if (showDetails) ...[
            const SizedBox(height: 8),
            Text(
              'Próximo nível: ${userStats.level + 1}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.sustainableGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}